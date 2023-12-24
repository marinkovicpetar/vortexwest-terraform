resource "aws_ecs_service" "ecs_frontend" {
  cluster                = aws_ecs_cluster.ecs_cluster.id 
  desired_count          = var.ecs_service_frontend_desired_count
  name                   = format("%s-%s-frontend", var.project_name, var.environment)
  task_definition        = aws_ecs_task_definition.ecs_frontend.arn

  load_balancer {
    container_name   = format("%s-%s-frontend", var.project_name, var.environment)
    container_port   = "80"
    target_group_arn = aws_lb_target_group.ecs_frontend.arn
  }
}

resource "aws_ecs_service" "ecs_backend" {
  cluster                = aws_ecs_cluster.ecs_cluster.id 
  desired_count          = var.ecs_service_backend_desired_count
  name                   = format("%s-%s-backend", var.project_name, var.environment)
  task_definition        = aws_ecs_task_definition.ecs_backend.arn

  load_balancer {
    container_name   = format("%s-%s-backend", var.project_name, var.environment)
    container_port   = "8000"
    target_group_arn = aws_lb_target_group.ecs_backend.arn
  }
}