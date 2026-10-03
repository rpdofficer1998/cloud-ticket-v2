output "certificate_arn" {
  description = "ARN of the ACM certificate"
  value       = aws_acm_certificate.this.arn
}

output "domain_name" {
  description = "Domain name covered by the certificate"
  value       = aws_acm_certificate.this.domain_name
}

output "domain_validation_options" {
  description = "DNS validation options for the ACM certificate"
  value       = aws_acm_certificate.this.domain_validation_options
}
