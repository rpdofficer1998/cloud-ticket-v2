module "networking" {
  source = "./modules/networking"

  vpc_cidr = var.vpc_cidr
}

module "security_groups" {
  source = "./modules/security-groups"

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

  aws_region         = var.aws_region
  project_name       = var.project_name
  environment        = var.environment
  ec2_instance_id    = module.ec2.instance_id
  sqs_queue_arn      = module.sqs.queue_arn
  ecr_repository_arn = module.ecr.repository_arn
}

module "vpc_endpoints" {
  source = "./modules/vpc-endpoints"

  aws_region   = var.aws_region
  project_name = var.project_name
  environment  = var.environment

  vpc_id = module.networking.vpc_id

  route_table_ids = module.networking.private_route_table_ids

  # Phase 1: use only the first private subnet (ap-southeast-2a)
  subnet_ids = [module.networking.private_subnet_ids[0]]

  ssm_security_group_ids = [
    module.security_groups.ssm_endpoint_security_group_id
  ]

  ecr_security_group_ids = [
    module.security_groups.ecr_endpoint_security_group_id
  ]
}

module "ec2" {
  source = "./modules/ec2"

  project_name = var.project_name
  environment  = var.environment

  ami_id = var.ami_id

  private_subnet_id = module.networking.private_subnet_ids[0]

  security_group_id = module.security_groups.ec2_security_group_id

  instance_profile_name = module.iam.ec2_instance_profile_name
}
