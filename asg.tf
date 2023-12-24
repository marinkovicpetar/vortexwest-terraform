resource "aws_launch_configuration" "lc_ecs" {
  name_prefix            = format("%s-%s-lc-ecs", var.project_name, var.environment)
  image_id               = data.aws_ami.ecs.id
  instance_type          = var.lc_ecs_instance_type
  security_groups        = [module.sg_asg_ecs.security_group_id]
  user_data              = base64encode(data.template_file.asg_ecs.rendered)
  iam_instance_profile   = aws_iam_instance_profile.iam_asg_ecs.name

  root_block_device {
    volume_type           = var.lc_ecs_volume_type
    volume_size           = var.lc_ecs_volume_size
    delete_on_termination = "true"
  }

  lifecycle {
    create_before_destroy = true
    
    ignore_changes = [
      user_data,
      image_id
    ]
  }
}

resource "aws_autoscaling_group" "asg_ecs" {
  name                      = format("%s-%s-asg-ecs", var.project_name, var.environment)
  max_size                  = var.asg_ecs_max_size
  min_size                  = var.asg_ecs_min_size
  desired_capacity          = var.asg_ecs_desired_capacity
  health_check_grace_period = 300
  health_check_type         = "EC2"
  launch_configuration      = aws_launch_configuration.lc_ecs.name
  vpc_zone_identifier       = module.vpc.private_subnets
  
  lifecycle {
    create_before_destroy = true
  }

  tag {
    key                 = "Name"
    value               = format("%s-%s-asg-ecs", var.project_name, var.environment)
    propagate_at_launch = true
  } 

  tag {
    key                 = "Environment"
    value               = var.environment
    propagate_at_launch = true
  }
}