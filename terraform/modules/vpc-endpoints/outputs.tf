output "s3_endpoint_id" {
  description = "ID of the S3 Gateway VPC endpoint"
  value       = aws_vpc_endpoint.s3.id
}

output "ssm_endpoint_id" {
  description = "ID of the SSM interface VPC endpoint"
  value       = aws_vpc_endpoint.ssm.id
}

output "ssmmessages_endpoint_id" {
  description = "ID of the SSM Messages interface VPC endpoint"
  value       = aws_vpc_endpoint.ssmmessages.id
}

output "ecr_api_endpoint_id" {
  description = "ID of the ECR API interface VPC endpoint"
  value       = aws_vpc_endpoint.ecr_api.id
}

output "ecr_dkr_endpoint_id" {
  description = "ID of the ECR Docker interface VPC endpoint"
  value       = aws_vpc_endpoint.ecr_dkr.id
}