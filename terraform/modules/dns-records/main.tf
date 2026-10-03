resource "aws_route53_record" "acm_validation" {
  for_each = {
    for dvo in var.alb_certificate_domain_validation_options :
    dvo.domain_name => dvo
  }

  allow_overwrite = true

  zone_id = var.zone_id
  name    = each.value.resource_record_name
  type    = each.value.resource_record_type
  ttl     = 60

  records = [each.value.resource_record_value]
}

resource "aws_acm_certificate_validation" "alb" {
  certificate_arn = var.alb_certificate_arn

  validation_record_fqdns = [
    for record in aws_route53_record.acm_validation :
    record.fqdn
  ]
}

resource "aws_route53_record" "cloudfront_acm_validation" {
  for_each = {
    for dvo in var.cloudfront_certificate_domain_validation_options :
    dvo.domain_name => dvo
  }

  allow_overwrite = true

  zone_id = var.zone_id
  name    = each.value.resource_record_name
  type    = each.value.resource_record_type
  ttl     = 60

  records = [each.value.resource_record_value]
}

resource "aws_acm_certificate_validation" "cloudfront" {
  provider = aws.us_east_1

  certificate_arn = var.cloudfront_certificate_arn

  validation_record_fqdns = [
    for record in aws_route53_record.cloudfront_acm_validation :
    record.fqdn
  ]
}
