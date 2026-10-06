variable "project_name" {
  description = "Project name"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "alb_arn" {
  description = "ARN of the Application Load Balancer"
  type        = string
}

variable "target_group_arn" {
  description = "ARN of the backend target group"
  type        = string
}

variable "autoscaling_group_name" {
  description = "Name of the application Auto Scaling Group"
  type        = string
}

variable "db_instance_id" {
  description = "Identifier of the RDS PostgreSQL instance"
  type        = string
}

variable "waf_web_acl_name" {
  description = "Name of the CloudFront WAF Web ACL"
  type        = string
}

variable "waf_scope" {
  description = "Scope of the WAF Web ACL"
  type        = string
  default     = "CLOUDFRONT"
}
