output "validated_alb_certificate_arn" {
  description = "Validated ACM certificate ARN for the ALB"
  value       = aws_acm_certificate_validation.alb.certificate_arn
}

output "validated_cloudfront_certificate_arn" {
  description = "Validated ACM certificate ARN for CloudFront"
  value       = aws_acm_certificate_validation.cloudfront.certificate_arn
}
