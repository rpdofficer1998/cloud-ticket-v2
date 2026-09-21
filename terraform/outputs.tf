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