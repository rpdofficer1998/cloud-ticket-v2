resource "aws_kms_key" "sqs" {
  description             = "KMS key for CloudTicket SQS encryption"
  deletion_window_in_days = 7

  enable_key_rotation = true

  tags = {
    Name        = "${var.project_name}-${var.environment}-sqs-kms"
    Project     = var.project_name
    Environment = var.environment
  }
}

resource "aws_kms_alias" "sqs" {
  name          = "alias/${var.project_name}-${var.environment}-sqs"
  target_key_id = aws_kms_key.sqs.key_id
}

resource "aws_sqs_queue" "orders" {
  name = "${var.project_name}-${var.environment}-orders"

  kms_master_key_id                 = aws_kms_key.sqs.arn
  kms_data_key_reuse_period_seconds = 300

  visibility_timeout_seconds = 30
  message_retention_seconds  = 345600

  tags = {
    Name        = "${var.project_name}-${var.environment}-orders"
    Project     = var.project_name
    Environment = var.environment
  }
}