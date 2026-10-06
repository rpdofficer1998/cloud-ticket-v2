data "aws_route53_zone" "main" {
  name         = "neotanzy.site"
  private_zone = false
}

resource "aws_route53_record" "alb" {
  zone_id = data.aws_route53_zone.main.zone_id
  name    = var.alb_domain_name
  type    = "A"

  alias {
    name                   = module.alb.alb_dns_name
    zone_id                = module.alb.alb_zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "cloudfront" {
  zone_id = data.aws_route53_zone.main.zone_id
  name    = var.cloudfront_domain_name
  type    = "A"

  alias {
    name                   = module.cloudfront.distribution_domain_name
    zone_id                = module.cloudfront.distribution_hosted_zone_id
    evaluate_target_health = false
  }
}

module "dns_records" {
  source = "./modules/dns-records"

  providers = {
    aws           = aws
    aws.us_east_1 = aws.us_east_1
  }

  zone_id = data.aws_route53_zone.main.zone_id

  alb_certificate_arn                       = module.alb_acm.certificate_arn
  alb_certificate_domain_validation_options = module.alb_acm.domain_validation_options

  cloudfront_certificate_arn                       = module.cloudfront_acm.certificate_arn
  cloudfront_certificate_domain_validation_options = module.cloudfront_acm.domain_validation_options
}

module "networking" {
  source = "./modules/networking"

  vpc_cidr = var.vpc_cidr
}

module "security_groups" {
  source = "./modules/security-groups"

  aws_region   = var.aws_region
  project_name = var.project_name
  environment  = var.environment
  vpc_id       = module.networking.vpc_id
}

module "kms" {
  source = "./modules/kms"

  project_name = var.project_name
  environment  = var.environment
}

module "ecr" {
  source = "./modules/ecr"

  project_name = var.project_name
  environment  = var.environment
  kms_key_arn  = module.kms.kms_key_arn
}

module "sqs" {
  source = "./modules/sqs"

  project_name = var.project_name
  environment  = var.environment
  kms_key_arn  = module.kms.kms_key_arn
}

module "iam" {
  source = "./modules/iam"

  aws_region   = var.aws_region
  project_name = var.project_name
  environment  = var.environment

  sqs_queue_arn   = module.sqs.queue_arn
  sqs_kms_key_arn = module.kms.kms_key_arn

  ecr_repository_arn = module.ecr.repository_arn

  image_tag_parameter_arn = module.ssm.image_tag_parameter_arn
  asg_arn                 = module.asg.autoscaling_group_arn

  rds_secret_arn = module.rds.master_user_secret_arn

  frontend_bucket_arn         = module.s3.bucket_arn
  cloudfront_distribution_arn = module.cloudfront.distribution_arn

}

module "vpc_endpoints" {
  source = "./modules/vpc-endpoints"

  aws_region   = var.aws_region
  project_name = var.project_name
  environment  = var.environment

  vpc_id = module.networking.vpc_id

  route_table_ids = module.networking.private_route_table_ids

  subnet_ids = module.networking.private_subnet_ids

  ssm_security_group_ids = [
    module.security_groups.ssm_endpoint_security_group_id
  ]

  ecr_security_group_ids = [
    module.security_groups.ecr_endpoint_security_group_id
  ]

  secrets_manager_security_group_ids = [
    module.security_groups.secrets_manager_endpoint_security_group_id
  ]

  sqs_security_group_ids = [
    module.security_groups.sqs_endpoint_security_group_id
  ]
}

module "rds" {
  source = "./modules/rds"

  project_name = var.project_name
  environment  = var.environment

  database_subnet_ids = module.networking.database_subnet_ids

  security_group_id = module.security_groups.rds_security_group_id

  kms_key_arn = module.kms.kms_key_arn

  db_username = var.db_username
}

module "s3" {
  source = "./modules/s3"

  project_name = var.project_name
  environment  = var.environment
}

module "cloudfront" {
  source = "./modules/cloudfront"

  providers = {
    aws           = aws
    aws.us_east_1 = aws.us_east_1
  }

  project_name = var.project_name
  environment  = var.environment

  s3_bucket_name = module.s3.bucket_name
  s3_bucket_arn  = module.s3.bucket_arn

  alb_origin_dns_name = var.alb_domain_name

  certificate_arn = module.dns_records.validated_cloudfront_certificate_arn

  cloudfront_domain_name = var.cloudfront_domain_name
}

module "cloudfront_acm" {
  source = "./modules/acm"

  providers = {
    aws = aws.us_east_1
  }

  project_name = var.project_name
  environment  = var.environment

  domain_name      = var.cloudfront_domain_name
  certificate_name = "cloudfront-certificate"
}

module "alb_acm" {
  source = "./modules/acm"

  project_name = var.project_name
  environment  = var.environment

  domain_name      = var.alb_domain_name
  certificate_name = "alb-certificate"
}

module "alb" {
  source = "./modules/alb"

  project_name = var.project_name
  environment  = var.environment

  vpc_id = module.networking.vpc_id

  public_subnet_ids = module.networking.public_subnet_ids

  security_group_id = module.security_groups.alb_security_group_id

  target_port       = 3000
  health_check_path = "/"

  certificate_arn = module.dns_records.validated_alb_certificate_arn
}

module "asg" {
  source = "./modules/asg"

  project_name = var.project_name
  environment  = var.environment

  ami_id        = var.ami_id
  instance_type = "t3.micro"

  security_group_id = module.security_groups.ec2_security_group_id

  instance_profile_name = module.iam.ec2_instance_profile_name

  private_subnet_ids = module.networking.private_subnet_ids

  target_group_arn = module.alb.target_group_arn

  aws_region               = var.aws_region
  ecr_repository_url       = module.ecr.repository_url
  rds_endpoint             = module.rds.db_endpoint
  rds_secret_arn           = module.rds.master_user_secret_arn
  sqs_queue_url            = module.sqs.queue_url
  image_tag_parameter_name = module.ssm.image_tag_parameter_name

  min_size         = 2
  desired_capacity = 2
  max_size         = 3
}

module "ssm" {
  source = "./modules/ssm"

  project_name      = var.project_name
  environment       = var.environment
  initial_image_tag = var.initial_image_tag
}

module "cloudwatch" {
  source = "./modules/cloudwatch"

  project_name = var.project_name
  environment  = var.environment
  aws_region   = var.aws_region

  alb_arn                = module.alb.alb_arn
  target_group_arn       = module.alb.target_group_arn
  autoscaling_group_name = module.asg.autoscaling_group_name
  db_instance_id         = module.rds.db_instance_id
  waf_web_acl_name       = module.cloudfront.waf_web_acl_name
}
