module "sg_asg_ecs" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "5.1.0"

  name        = format("%s-%s-sg-asg-ecs", var.project_name, var.environment)
  description = "Allow traffic from / to ECS instances in AutoScaling group"
  vpc_id      = module.vpc.vpc_id

  ingress_with_cidr_blocks = [
    {
      from_port   = 0
      to_port     = 65535
      protocol    = "tcp"
      description = "Allow local VPC traffic to ECS instances in Autoscaling group"
      cidr_blocks = module.vpc.vpc_cidr_block
    },
  ]

  egress_with_cidr_blocks = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      description = "Allow outbound traffic to everywhere"
      cidr_blocks = var.default_route
    },    
  ]

  tags = {
    Environment = var.environment
  }
}

module "sg_rds" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "5.1.0"

  name        = format("%s-%s-sg-rds", var.project_name, var.environment)
  description = "Allow local VPC traffic to RDS PostgreSQL"
  vpc_id      = module.vpc.vpc_id

  ingress_with_cidr_blocks = [
    {
      from_port   = 5432
      to_port     = 5432
      protocol    = "tcp"
      description = "Allow local VPC traffic to RDS PostgreSQL"
      cidr_blocks = module.vpc.vpc_cidr_block
    },
  ]

  egress_with_cidr_blocks = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      description = "Allow outbound traffic to everywhere"
      cidr_blocks = var.default_route
    },    
  ]

  tags = {
    Environment = var.environment
  }
}

module "sg_alb" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "5.1.0"

  name        = format("%s-%s-sg-alb", var.project_name, var.environment)
  description = "Allow Internet traffic to ALB"
  vpc_id      = module.vpc.vpc_id

  ingress_with_cidr_blocks = [
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      description = "Allow Internet HTTP traffic to ALB"
      cidr_blocks = var.default_route
    }
  ]
  
  egress_with_cidr_blocks = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      description = "Allow outbound traffic to everywhere"
      cidr_blocks = var.default_route
    },    
  ]

  tags = {
    Environment = var.environment
  }
}