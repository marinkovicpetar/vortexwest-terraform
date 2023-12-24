resource "aws_ecs_task_definition" "ecs_frontend" {
  container_definitions    = data.template_file.ecs_task_frontend.rendered
  family                   = format("%s-%s-frontend", var.project_name, var.environment)
  network_mode             = "bridge"
  memory                   = var.ecs_task_frontend_memory
  cpu                      = var.ecs_task_frontend_cpu
  requires_compatibilities = ["EC2"]
  execution_role_arn       = aws_iam_role.iam_frontend.arn

  tags = {
    Name        = format("%s-%s-frontend", var.project_name, var.environment)
    Environment = var.environment
  }
}

resource "aws_ecs_task_definition" "ecs_backend" {
  container_definitions    = data.template_file.ecs_task_backend.rendered
  family                   = format("%s-%s-backend", var.project_name, var.environment)
  network_mode             = "bridge"
  memory                   = var.ecs_task_backend_memory
  cpu                      = var.ecs_task_backend_cpu
  requires_compatibilities = ["EC2"]
  execution_role_arn       = aws_iam_role.iam_backend.arn

  tags = {
    Name        = format("%s-%s-backend", var.project_name, var.environment)
    Environment = var.environment
  }
}