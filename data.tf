data "aws_ami" "ecs" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-ecs-hvm-*-x86_64-ebs*"]
  }
}

data "template_file" "asg_ecs" {
  template = file("${path.module}/templates/asg_ecs.tpl")
  
  vars = {
    project_name = var.project_name
    environment  = var.environment
  }
}

data "template_file" "ecs_task_frontend" {
  template = file("${path.module}/templates/ecs_frontend.tpl")
  
  vars = {
    project_name             = var.project_name
    environment              = var.environment
    region                   = var.region
    ecs_task_frontend_cpu    = var.ecs_task_frontend_cpu
    ecs_task_frontend_memory = var.ecs_task_frontend_memory
  }
}

data "template_file" "ecs_task_backend" {
  template = file("${path.module}/templates/ecs_backend.tpl")
  
  vars = {
    project_name              = var.project_name
    environment               = var.environment
    region                    = var.region
    ecs_task_backend_cpu      = var.ecs_task_backend_cpu
    ecs_task_backend_memory   = var.ecs_task_backend_memory
    env_var_postgres_name     = "postgres"
    env_var_postgres_user     = module.rds.db_instance_username
    env_var_postgres_password = random_password.rds.result
    env_var_postgres_host     = module.rds.db_instance_address
    env_var_postgres_port     = module.rds.db_instance_port
  }
}