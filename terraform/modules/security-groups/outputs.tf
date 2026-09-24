output "alb_security_group_id" {
  description = "ID of the ALB security group"
  value       = aws_security_group.alb.id
}

output "ec2_security_group_id" {
  description = "ID of the EC2 security group"
  value       = aws_security_group.ec2.id
}

output "rds_security_group_id" {
  description = "ID of the RDS security group"
  value       = aws_security_group.rds.id
}

output "ssm_endpoint_security_group_id" {
  description = "ID of the SSM interface endpoint security group"
  value       = aws_security_group.ssm_endpoint.id
}

output "ecr_endpoint_security_group_id" {
  description = "Security group ID for ECR interface VPC endpoints"
  value       = aws_security_group.ecr_endpoint.id
}