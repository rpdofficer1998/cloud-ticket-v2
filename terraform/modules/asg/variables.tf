variable "aws_region" {
  description = "AWS region where the application runs"
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

variable "ami_id" {
  description = "AMI ID used to launch application instances"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "security_group_id" {
  description = "Security group attached to application instances"
  type        = string
}

variable "instance_profile_name" {
  description = "IAM instance profile attached to application instances"
  type        = string
}

variable "private_subnet_ids" {
  description = "Private subnet IDs where application instances will be launched"
  type        = list(string)
}

variable "target_group_arn" {
  description = "ALB target group ARN for application instances"
  type        = string
}

variable "min_size" {
  description = "Minimum number of application instances"
  type        = number
  default     = 2
}

variable "desired_capacity" {
  description = "Desired number of application instances"
  type        = number
  default     = 2
}

variable "max_size" {
  description = "Maximum number of application instances"
  type        = number
  default     = 3
}

variable "ecr_repository_url" {
  description = "ECR repository URI for the backend container image"
  type        = string
}

variable "rds_secret_arn" {
  description = "ARN of the Secrets Manager secret containing RDS credentials"
  type        = string
}

variable "rds_endpoint" {
  description = "RDS endpoint used by the backend application"
  type        = string
}

variable "sqs_queue_url" {
  description = "SQS queue URL used by the backend application"
  type        = string
}

variable "image_tag_parameter_name" {
  description = "SSM Parameter Store name containing the current backend image tag"
  type        = string
}
