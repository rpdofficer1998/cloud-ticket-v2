resource "aws_ssm_parameter" "image_tag" {
  name = "/${var.project_name}/${var.environment}/image-tag"

  type  = "String"
  value = var.initial_image_tag

  description = "Current CloudTicket backend Docker image tag"

  tags = {
    Name        = "${var.project_name}-${var.environment}-image-tag"
    Project     = var.project_name
    Environment = var.environment
  }
}
