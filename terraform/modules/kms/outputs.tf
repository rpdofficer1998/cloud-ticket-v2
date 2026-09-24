output "kms_key_id" {
  description = "ID of the CloudTicket workload KMS key"
  value       = aws_kms_key.workload.key_id
}

output "kms_key_arn" {
  description = "ARN of the CloudTicket workload KMS key"
  value       = aws_kms_key.workload.arn
}