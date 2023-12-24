# frontend ECS service IAM entities
resource "aws_iam_role" "iam_frontend" {
  name               = format("%s-%s-ecs-frontend", var.project_name, var.environment)
  assume_role_policy = file("${path.module}/iam/assume-policies/ecs-task.json")
}

resource "aws_iam_policy" "iam_frontend" {
  name   = format("%s-%s-ecs-frontend", var.project_name, var.environment)
  policy = file("${path.module}/iam/ecs/frontend.json")
}

resource "aws_iam_role_policy_attachment" "iam_frontend" {
  role       = aws_iam_role.iam_frontend.name
  policy_arn = aws_iam_policy.iam_frontend.arn
}

# backend ECS service IAM entities
resource "aws_iam_role" "iam_backend" {
  name               = format("%s-%s-ecs-backend", var.project_name, var.environment)
  assume_role_policy = file("${path.module}/iam/assume-policies/ecs-task.json")
}

resource "aws_iam_policy" "iam_backend" {
  name   = format("%s-%s-ecs-backend", var.project_name, var.environment)
  policy = file("${path.module}/iam/ecs/backend.json")
}

resource "aws_iam_role_policy_attachment" "iam_backend" {
  role       = aws_iam_role.iam_backend.name
  policy_arn = aws_iam_policy.iam_backend.arn
}
