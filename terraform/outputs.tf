output "vpc_id" {
  description = "CloudTicket V2 VPC ID"
  value       = module.networking.vpc_id
}

output "public_subnet_ids" {
  description = "CloudTicket V2 public subnet IDs"
  value       = module.networking.public_subnet_ids
}

output "private_subnet_ids" {
  description = "CloudTicket V2 private application subnet IDs"
  value       = module.networking.private_subnet_ids
}

output "database_subnet_ids" {
  description = "CloudTicket V2 private database subnet IDs"
  value       = module.networking.database_subnet_ids
}

output "ec2_instance_id" {
  description = "ID of the CloudTicket application EC2 instance"
  value       = module.ec2.instance_id
}

output "ec2_private_ip" {
  description = "Private IP address of the CloudTicket application EC2 instance"
  value       = module.ec2.private_ip
}

output "ecr_repository_name" {
  description = "Name of the CloudTicket backend ECR repository"
  value       = module.ecr.repository_name
}

output "ecr_repository_url" {
  description = "URL of the CloudTicket backend ECR repository"
  value       = module.ecr.repository_url
}