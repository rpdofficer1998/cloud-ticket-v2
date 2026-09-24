resource "aws_security_group" "alb" {
  name        = "${var.project_name}-${var.environment}-alb-sg"
  description = "Security group for the Application Load Balancer"
  vpc_id      = var.vpc_id

  tags = {
    Name        = "${var.project_name}-${var.environment}-alb-sg"
    Project     = var.project_name
    Environment = var.environment
  }
}

resource "aws_vpc_security_group_ingress_rule" "alb_http" {
  security_group_id = aws_security_group.alb.id

  description = "Allow HTTP traffic from the internet"

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 80
  to_port     = 80
  ip_protocol = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "alb_https" {
  security_group_id = aws_security_group.alb.id

  description = "Allow HTTPS traffic from the internet"

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 443
  to_port     = 443
  ip_protocol = "tcp"
}

resource "aws_security_group" "ec2" {
  name        = "${var.project_name}-${var.environment}-ec2-sg"
  description = "Security group for EC2 application instances"
  vpc_id      = var.vpc_id

  tags = {
    Name        = "${var.project_name}-${var.environment}-ec2-sg"
    Project     = var.project_name
    Environment = var.environment
  }
}

resource "aws_vpc_security_group_egress_rule" "ec2_to_ssm" {
  security_group_id = aws_security_group.ec2.id

  description = "Allow HTTPS traffic to SSM interface endpoint"

  referenced_security_group_id = aws_security_group.ssm_endpoint.id

  from_port   = 443
  to_port     = 443
  ip_protocol = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "ec2_to_ecr" {
  security_group_id = aws_security_group.ec2.id

  description = "Allow HTTPS traffic to ECR interface endpoint"

  referenced_security_group_id = aws_security_group.ecr_endpoint.id

  from_port   = 443
  to_port     = 443
  ip_protocol = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "ec2_from_alb" {
  security_group_id = aws_security_group.ec2.id

  description = "Allow traffic from the ALB security group"

  referenced_security_group_id = aws_security_group.alb.id
  from_port                    = 3000
  to_port                      = 3000
  ip_protocol                  = "tcp"
}

resource "aws_security_group" "rds" {
  name        = "${var.project_name}-${var.environment}-rds-sg"
  description = "Security group for RDS database"
  vpc_id      = var.vpc_id

  tags = {
    Name        = "${var.project_name}-${var.environment}-rds-sg"
    Project     = var.project_name
    Environment = var.environment
  }
}

resource "aws_vpc_security_group_ingress_rule" "rds_from_ec2" {
  security_group_id = aws_security_group.rds.id

  description = "Allow traffic from the EC2 security group"

  referenced_security_group_id = aws_security_group.ec2.id
  from_port                    = 5432
  to_port                      = 5432
  ip_protocol                  = "tcp"
}

resource "aws_security_group" "ssm_endpoint" {
  name        = "${var.project_name}-${var.environment}-ssm-endpoint"
  description = "Security group for the SSM interface endpoint"
  vpc_id      = var.vpc_id

  tags = {
    Name        = "${var.project_name}-${var.environment}-ssm-endpoint"
    Project     = var.project_name
    Environment = var.environment
  }
}

resource "aws_vpc_security_group_ingress_rule" "ssm_from_ec2" {
  security_group_id = aws_security_group.ssm_endpoint.id

  description = "Allow HTTPS traffic from EC2 instances"

  referenced_security_group_id = aws_security_group.ec2.id
  from_port                    = 443
  to_port                      = 443
  ip_protocol                  = "tcp"
}

resource "aws_security_group" "ecr_endpoint" {
  name        = "${var.project_name}-${var.environment}-ecr-endpoint"
  description = "Security group for the ECR interface endpoint"
  vpc_id      = var.vpc_id

  tags = {
    Name        = "${var.project_name}-${var.environment}-ecr-endpoint"
    Project     = var.project_name
    Environment = var.environment
  }
}

resource "aws_vpc_security_group_ingress_rule" "ecr_from_ec2" {
  security_group_id = aws_security_group.ecr_endpoint.id

  description = "Allow HTTPS traffic from EC2 instances"

  referenced_security_group_id = aws_security_group.ec2.id

  from_port   = 443
  to_port     = 443
  ip_protocol = "tcp"
}
