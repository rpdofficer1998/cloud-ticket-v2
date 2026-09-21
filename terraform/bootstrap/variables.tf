variable "aws_region" {
  description = "AWS region for the Terraform bootstrap resources"
  type        = string
  default     = "ap-southeast-2"
}

variable "tfstate_bucket_name" {
  description = "Globally unique S3 bucket name for Terraform remote state"
  type        = string
}