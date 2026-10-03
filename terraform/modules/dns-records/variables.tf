variable "zone_id" {
  description = "Route 53 hosted zone ID"
  type        = string
}

variable "alb_certificate_arn" {
  description = "ARN of the ACM certificate"
  type        = string
}

variable "alb_certificate_domain_validation_options" {
  description = "ACM DNS validation options"

  type = set(object({
    domain_name           = string
    resource_record_name  = string
    resource_record_type  = string
    resource_record_value = string
  }))
}

variable "cloudfront_certificate_arn" {
  description = "ARN of the CloudFront ACM certificate"
  type        = string
}

variable "cloudfront_certificate_domain_validation_options" {
  description = "DNS validation options for the CloudFront ACM certificate"

  type = set(object({
    domain_name           = string
    resource_record_name  = string
    resource_record_type  = string
    resource_record_value = string
  }))
}
