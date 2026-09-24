resource "aws_kms_key" "workload" {
  description             = "KMS key for CloudTicket workload data encryption"
  deletion_window_in_days = 7

  enable_key_rotation = true

  tags = {
    Name        = "${var.project_name}-${var.environment}-workload-kms"
    Project     = var.project_name
    Environment = var.environment
  }
}

resource "aws_kms_alias" "workload" {
  name          = "alias/${var.project_name}-${var.environment}-workload"
  target_key_id = aws_kms_key.workload.key_id
}