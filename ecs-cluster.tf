resource "aws_ecs_cluster" "ecs_cluster" {
  name = format("%s-%s-ecs", var.project_name, var.environment)
  
  tags = {
    Name        = format("%s-%s-ecs", var.project_name, var.environment)
    Environment = var.environment
  }
}