variable "aws_region" {
  description = "AWS region where the resources will be created"
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

variable "vpc_id" {
  description = "ID of the VPC where the endpoint will be created"
  type        = string
}

variable "route_table_ids" {
  description = "Route table IDs associated with private subnets"
  type        = list(string)
}

variable "subnet_ids" {
  description = "Subnet IDs where interface endpoints will be created"
  type        = list(string)
}

variable "ssm_security_group_ids" {
  description = "Security group IDs attached to SSM interface endpoints"
  type        = list(string)
}

variable "ecr_security_group_ids" {
  description = "Security group IDs attached to ECR interface endpoints"
  type        = list(string)
}