variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "project_name" {
  description = "Project name used for resource naming"
  type        = string
}

variable "environment" {
  description = "Deployment environment"
  type        = string
}

variable "sqs_queue_arn" {
  description = "ARN of the SQS queue that EC2 is allowed to send messages to"
  type        = string
}

variable "sqs_kms_key_arn" {
  description = "ARN of the KMS key used to encrypt the SQS queue"
  type        = string
}

variable "ecr_repository_arn" {
  description = "ARN of the ECR repository that GitHub Actions is allowed to push to"
  type        = string
}

variable "rds_secret_arn" {
  description = "ARN of the RDS master user secret in Secrets Manager"
  type        = string
}

variable "frontend_bucket_arn" {
  description = "ARN of the frontend S3 bucket that GitHub Actions is allowed to operate on"
  type        = string
}

variable "cloudfront_distribution_arn" {
  description = "ARN of the CloudFront distribution that GitHub Actions is allowed to invalidate"
  type        = string
}
