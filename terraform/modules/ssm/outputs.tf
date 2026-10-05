output "image_tag_parameter_name" {
  description = "Name of the SSM Parameter Store parameter containing the current image tag"
  value       = aws_ssm_parameter.image_tag.name
}

output "image_tag_parameter_arn" {
  description = "ARN of the SSM Parameter Store parameter containing the current image tag"
  value       = aws_ssm_parameter.image_tag.arn
}
