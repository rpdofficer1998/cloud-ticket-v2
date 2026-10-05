resource "aws_launch_template" "app" {
  name_prefix = "${var.project_name}-${var.environment}-app-"

  image_id      = var.ami_id
  instance_type = var.instance_type

  user_data = base64encode(<<-EOF
    #!/bin/bash
    set -euo pipefail

    LOG_FILE="/var/log/cloudticket-user-data.log"

    exec > >(tee -a "$${LOG_FILE}") 2>&1

    echo "=================================================="
    echo "CloudTicket ASG instance bootstrap started"
    echo "Time: $(date -Is)"
    echo "=================================================="

    AWS_REGION="${var.aws_region}"
    ECR_REPOSITORY_URL="${var.ecr_repository_url}"
    RDS_SECRET_ARN="${var.rds_secret_arn}"
    RDS_ENDPOINT="${var.rds_endpoint}"
    SQS_QUEUE_URL="${var.sqs_queue_url}"
    IMAGE_TAG_PARAMETER_NAME="${var.image_tag_parameter_name}"

    echo "[1/7] Waiting for Docker..."

    until systemctl is-active --quiet docker; do
      echo "Docker is not ready yet. Waiting..."
      sleep 5
    done

    echo "Docker is ready."

    echo "[2/7] Reading image tag from SSM Parameter Store..."

    IMAGE_TAG=$(aws ssm get-parameter \
      --name "$${IMAGE_TAG_PARAMETER_NAME}" \
      --region "$${AWS_REGION}" \
      --query 'Parameter.Value' \
      --output text)

    if [ -z "$${IMAGE_TAG}" ] || [ "$${IMAGE_TAG}" = "None" ]; then
      echo "ERROR: Failed to retrieve image tag from Parameter Store."
      exit 1
    fi

    echo "Image tag retrieved successfully."

    echo "[3/7] Logging in to ECR..."

    ECR_REGISTRY="$${ECR_REPOSITORY_URL%%/*}"

    aws ecr get-login-password \
      --region "$${AWS_REGION}" | \
      docker login \
        --username AWS \
        --password-stdin "$${ECR_REGISTRY}"

    echo "ECR login successful."

    echo "[4/7] Pulling backend image..."

    docker pull "$${ECR_REPOSITORY_URL}:$${IMAGE_TAG}"

    echo "Docker image pulled successfully."

    echo "[5/7] Retrieving database credentials from Secrets Manager..."

    SECRET_JSON=$(aws secretsmanager get-secret-value \
      --secret-id "$${RDS_SECRET_ARN}" \
      --region "$${AWS_REGION}" \
      --query 'SecretString' \
      --output text)

    if [ -z "$${SECRET_JSON}" ] || [ "$${SECRET_JSON}" = "None" ]; then
      echo "ERROR: Failed to retrieve RDS secret."
      exit 1
    fi

    DB_USER=$(echo "$${SECRET_JSON}" | jq -r '.username')
    DB_PASSWORD=$(echo "$${SECRET_JSON}" | jq -r '.password')

    if [ -z "$${DB_USER}" ] || [ "$${DB_USER}" = "null" ]; then
      echo "ERROR: Database username was not found in the secret."
      exit 1
    fi

    if [ -z "$${DB_PASSWORD}" ] || [ "$${DB_PASSWORD}" = "null" ]; then
      echo "ERROR: Database password was not found in the secret."
      exit 1
    fi

    echo "Database credentials retrieved successfully."

    echo "[6/7] Starting CloudTicket backend..."

    docker rm -f cloudticket-backend-v2 || true

    docker run -d \
      --name cloudticket-backend-v2 \
      --restart unless-stopped \
      -p 3000:3000 \
      -e NODE_ENV=production \
      -e AWS_DEFAULT_REGION="$${AWS_REGION}" \
      -e SQS_QUEUE_URL="$${SQS_QUEUE_URL}" \
      -e DB_HOST="$${RDS_ENDPOINT}" \
      -e DB_PORT=5432 \
      -e DB_NAME="cloudticketv2" \
      -e DB_USER="$${DB_USER}" \
      -e DB_PASSWORD="$${DB_PASSWORD}" \
      "$${ECR_REPOSITORY_URL}:$${IMAGE_TAG}"

    unset SECRET_JSON DB_USER DB_PASSWORD

    echo "[7/7] Verifying backend container..."

    sleep 5

    if docker ps --filter "name=cloudticket-backend-v2" --filter "status=running" | grep -q cloudticket-backend-v2; then
      echo "CloudTicket backend container is running."
    else
      echo "ERROR: CloudTicket backend container failed to start."
      docker logs cloudticket-backend-v2 || true
      exit 1
    fi

    echo "=================================================="
    echo "CloudTicket ASG instance bootstrap completed"
    echo "Time: $(date -Is)"
    echo "Image tag: $${IMAGE_TAG}"
    echo "=================================================="

    EOF
  )

  iam_instance_profile {
    name = var.instance_profile_name
  }

  vpc_security_group_ids = [
    var.security_group_id
  ]

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 2
  }

  block_device_mappings {
    device_name = "/dev/sda1"

    ebs {
      volume_type           = "gp3"
      volume_size           = 8
      encrypted             = true
      delete_on_termination = true
    }
  }

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name        = "${var.project_name}-${var.environment}-app"
      Project     = var.project_name
      Environment = var.environment
      Deployment  = "cloudticket-v2-backend"
    }
  }
}

resource "aws_autoscaling_group" "app" {
  name = "${var.project_name}-${var.environment}-asg"

  min_size         = var.min_size
  desired_capacity = var.desired_capacity
  max_size         = var.max_size

  vpc_zone_identifier = var.private_subnet_ids

  target_group_arns = [
    var.target_group_arn
  ]

  health_check_type         = "ELB"
  health_check_grace_period = 180

  instance_refresh {
    strategy = "Rolling"

    preferences {
      min_healthy_percentage = 50
      instance_warmup        = 180
      max_healthy_percentage = 150
    }
  }

  launch_template {
    id      = aws_launch_template.app.id
    version = "$Latest"
  }

  tag {
    key                 = "Project"
    value               = var.project_name
    propagate_at_launch = true
  }

  tag {
    key                 = "Environment"
    value               = var.environment
    propagate_at_launch = true
  }

  tag {
    key                 = "Deployment"
    value               = "cloudticket-v2-backend"
    propagate_at_launch = true
  }
}
