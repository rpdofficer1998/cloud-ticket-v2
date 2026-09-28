variable "aws_region" {
  description = "AWS region for CloudTicket V2"
  type        = string
  default     = "ap-southeast-2"
}

variable "vpc_cidr" {
  description = "CIDR block for the CloudTicket V2 VPC"
  type        = string
  default     = "10.1.0.0/16"
}

variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "environment" {
  description = "Deployment environment"
  type        = string
}

variable "ami_id" {
  description = "AMI ID for the EC2 instance"
  type        = string
}

variable "db_username" {
  description = "Master username for the PostgreSQL database"
  type        = string
}

variable "rds_availability_zone" {
  description = "Availability Zone for the CloudTicket RDS instance"
  type        = string
  default     = "ap-southeast-2a"
}