variable "project_name" {
  description = "Project name used for resource naming"
  type        = string
}

variable "environment" {
  description = "Deployment environment"
  type        = string
}

variable "ami_id" {
  description = "AMI ID used to launch the EC2 instance"
  type        = string
}

variable "private_subnet_id" {
  description = "Private subnet ID for the EC2 instance"
  type        = string
}

variable "security_group_id" {
  description = "Security group ID attached to the EC2 instance"
  type        = string
}

variable "instance_profile_name" {
  description = "IAM instance profile attached to the EC2 instance"
  type        = string
}