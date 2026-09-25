resource "aws_instance" "app" {
  ami           = var.ami_id
  instance_type = "t3.micro"

  subnet_id = var.private_subnet_id

  iam_instance_profile = var.instance_profile_name

  vpc_security_group_ids = [
    var.security_group_id
  ]

  root_block_device {
    volume_type           = "gp3"
    volume_size           = 10
    encrypted             = true
    delete_on_termination = true
  }

  tags = {
    Name        = "${var.project_name}-${var.environment}-app"
    Project     = var.project_name
    Environment = var.environment
    Deployment  = "cloudticket-v2-backend"
  }
}