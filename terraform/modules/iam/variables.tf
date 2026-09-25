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

variable "ec2_instance_id" {
  description = "ID of the EC2 instance that GitHub Actions is allowed to deploy to via SSM"
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