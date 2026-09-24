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

variable "ecr_repository_arn" {
  description = "ARN of the ECR repository that GitHub Actions is allowed to push to"
  type        = string
}