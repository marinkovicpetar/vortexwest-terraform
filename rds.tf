module "rds" {
  source  = "terraform-aws-modules/rds/aws"
  version = "6.3.0"

  identifier                  = format("%s-%s-rds", var.project_name, var.environment)
  engine                      = var.rds_engine
  engine_version              = var.rds_engine_version
  family                      = var.rds_family
  instance_class              = var.rds_instance_class
  allocated_storage           = var.rds_allocated_storage
  max_allocated_storage       = var.rds_max_allocated_storage
  username                    = var.rds_username
  port                        = var.rds_port
  manage_master_user_password = false
  password                    = random_password.rds.result
  db_subnet_group_name        = module.vpc.database_subnet_group
  vpc_security_group_ids      = [module.sg_rds.security_group_id]
  create_db_parameter_group   = false
  maintenance_window          = var.rds_maintenance_window
  backup_window               = var.rds_backup_window
  backup_retention_period     = var.rds_backup_retention_period
  skip_final_snapshot         = var.rds_skip_final_snapshot
  deletion_protection         = var.rds_deletion_protection
  copy_tags_to_snapshot       = var.rds_copy_tags_to_snapshot

  tags = {
    Environment = var.environment
  }
}