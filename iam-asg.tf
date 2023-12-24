# ECS IAM ASG entities - roles, instance profile and policy attachments
resource "aws_iam_role" "iam_asg_ecs" {
  name               = format("%s-%s-asg-ecs", var.project_name, var.environment)
  assume_role_policy = file("${path.module}/iam/assume-policies/ec2.json")
}

resource "aws_iam_role_policy_attachment" "iam_asg_ecs_service_role" {
  role       = aws_iam_role.iam_asg_ecs.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_role_policy_attachment" "iam_asg_ecs_ssm" {
  role       = aws_iam_role.iam_asg_ecs.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "iam_asg_ecs" {
  name = format("%s-%s-asg-ecs", var.project_name, var.environment)
  role = aws_iam_role.iam_asg_ecs.id
}