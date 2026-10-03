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

variable "alb_origin_dns_name" {
  description = "Hostname used by CloudFront to connect to the ALB"
  type        = string
}

variable "certificate_arn" {
  description = "Validated ACM certificate ARN for CloudFront"
  type        = string
}

variable "cloudfront_domain_name" {
  description = "DNS name used to access CloudFront"
  type        = string
}
