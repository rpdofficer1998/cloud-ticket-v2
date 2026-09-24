resource "aws_sqs_queue" "orders" {
  name = "${var.project_name}-${var.environment}-orders"

  kms_master_key_id                 = var.kms_key_arn
  kms_data_key_reuse_period_seconds = 300

  visibility_timeout_seconds = 30
  message_retention_seconds  = 345600

  tags = {
    Name        = "${var.project_name}-${var.environment}-orders"
    Project     = var.project_name
    Environment = var.environment
  }
}