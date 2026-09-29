variable "project_name" {
  description = "Project name used for resource naming and tagging"
  type        = string
}

variable "environment" {
  description = "Environment name such as dev or prod"
  type        = string
}

variable "s3_bucket_name" {
  description = "Name of the S3 bucket used for the frontend"
  type        = string
}

variable "s3_bucket_arn" {
  description = "ARN of the S3 bucket used for the frontend"
  type        = string
}
