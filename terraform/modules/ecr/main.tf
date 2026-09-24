resource "aws_ecr_repository" "backend" {
  name = "${var.project_name}-${var.environment}-backend"

  image_scanning_configuration {
    scan_on_push = true
  }

  encryption_configuration {
    encryption_type = "KMS"
    kms_key         = var.kms_key_arn
  }

  image_tag_mutability = "MUTABLE"

  tags = {
    Name        = "${var.project_name}-${var.environment}-backend"
    Project     = var.project_name
    Environment = var.environment
  }
}