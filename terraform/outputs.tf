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

output "frontend_bucket_name" {
  value = module.s3.bucket_name
}

output "cloudfront_distribution_id" {
  value = module.cloudfront.distribution_id
}

output "rds_endpoint" {
  description = "Endpoint address of the CloudTicket RDS PostgreSQL instance"
  value       = module.rds.db_endpoint
}

output "rds_master_user_secret_arn" {
  description = "ARN of the Secrets Manager secret containing the RDS master credentials"
  value       = module.rds.master_user_secret_arn
  sensitive   = true
}

output "queue_url" {
  value = module.sqs.queue_url
}
