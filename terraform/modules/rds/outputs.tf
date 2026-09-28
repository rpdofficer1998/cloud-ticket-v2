output "db_instance_id" {
  description = "ID of the RDS PostgreSQL instance"
  value       = aws_db_instance.this.id
}

output "db_endpoint" {
  description = "Endpoint address of the RDS PostgreSQL instance"
  value       = aws_db_instance.this.address
}

output "db_port" {
  description = "Port of the RDS PostgreSQL instance"
  value       = aws_db_instance.this.port
}

output "master_user_secret_arn" {
  description = "ARN of the Secrets Manager secret containing the RDS master credentials"
  value       = aws_db_instance.this.master_user_secret[0].secret_arn
}