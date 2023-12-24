resource "aws_cloudwatch_log_group" "ecs_frontend" {
  name = format("/ecs/%s-%s-frontend", var.project_name, var.environment)

  tags = {
    Name        = format("%s-%s-frontend", var.project_name, var.environment)
    Environment = var.environment
  }
}

resource "aws_cloudwatch_log_group" "ecs_backend" {
  name = format("/ecs/%s-%s-backend", var.project_name, var.environment)

  tags = {
    Name        = format("%s-%s-backend", var.project_name, var.environment)
    Environment = var.environment
  }
}
