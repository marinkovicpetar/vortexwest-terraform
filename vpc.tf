module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.4.0"

  name = format("%s-%s-vpc", var.project_name, var.environment)
  cidr = var.vpc_cidr

  enable_dns_hostnames   = var.vpc_enable_dns_hostnames
  enable_nat_gateway     = var.vpc_enable_nat_gateway
  single_nat_gateway     = var.vpc_single_nat_gateway
  one_nat_gateway_per_az = var.vpc_one_nat_gateway_per_az

  azs                 = [format("%sa", var.region), format("%sb", var.region), format("%sc", var.region)]
  private_subnets     = var.vpc_private_subnets
  public_subnets      = var.vpc_public_subnets
  database_subnets    = var.vpc_database_subnets

  database_subnet_group_name = format("%s-%s-db", var.project_name, var.environment)

  tags = {
    Environment = var.environment
  }
}
