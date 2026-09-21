module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "6.7.3"

  name = "cloudticket-v2-vpc"

  cidr = var.vpc_cidr

  azs = [
    "ap-southeast-2a",
    "ap-southeast-2b",
  ]

  public_subnets = [
    "10.1.1.0/24",
    "10.1.2.0/24",
  ]

  private_subnets = [
    "10.1.11.0/24",
    "10.1.12.0/24",
  ]

  database_subnets = [
    "10.1.101.0/24",
    "10.1.102.0/24",
  ]

  enable_nat_gateway = false
  single_nat_gateway = true

  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Project     = "cloudticket-v2"
    Environment = "demo"
    ManagedBy   = "terraform"
  }
}