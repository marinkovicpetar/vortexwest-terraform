resource "aws_lb" "alb" {
  name            = format("%s-%s-alb", var.project_name, var.environment)
  internal        = false
  subnets         = module.vpc.public_subnets
  security_groups = [module.sg_alb.security_group_id]

  tags = {
    Name        = format("%s-%s-alb", var.project_name, var.environment)
    Environment = var.environment
  }
}

resource "aws_lb_listener" "alb_listener_80" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type  = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "Request not valid"
      status_code  = "400"
    }
  }
}

# frontend ECS service ALB resources
resource "aws_lb_target_group" "ecs_frontend" { 
  name                 = format("%s-%s-ecs-front", var.project_name, var.environment)
  port                 = "80"
  protocol             = "HTTP"
  vpc_id               = module.vpc.vpc_id
  target_type          = "instance"
  deregistration_delay = 60

  health_check {
    healthy_threshold   = "3"
    interval            = "30"
    timeout             = "5"
    port                = "traffic-port"
    path                = "/"
    protocol            = "HTTP"
    unhealthy_threshold = "3"
  }

  tags = {
    Name        = format("%s-%s-ecs-frontend", var.project_name, var.environment)
    Environment = var.environment
  }
}

resource "aws_lb_listener_rule" "ecs_frontend_80" {
  listener_arn = aws_lb_listener.alb_listener_80.arn
  priority     = 1

  action {
    type = "forward"
    target_group_arn = aws_lb_target_group.ecs_frontend.arn 
  }

  condition {
    host_header {
      values = [ var.frontend_url ]
    }
  }
}

# backend ECS service ALB resources
resource "aws_lb_target_group" "ecs_backend" { 
  name                 = format("%s-%s-ecs-back", var.project_name, var.environment)
  port                 = "8000"
  protocol             = "HTTP"
  vpc_id               = module.vpc.vpc_id
  target_type          = "instance"
  deregistration_delay = 60

  health_check {
    healthy_threshold   = "3"
    interval            = "30"
    timeout             = "5"
    port                = "traffic-port"
    path                = "/swagger/"
    protocol            = "HTTP"
    unhealthy_threshold = "3"
  }

  tags = {
    Name        = format("%s-%s-ecs-backend", var.project_name, var.environment)
    Environment = var.environment
  }
}

resource "aws_lb_listener_rule" "ecs_backend_80" {
  listener_arn = aws_lb_listener.alb_listener_80.arn
  priority     = 2

  action {
    type = "forward"
    target_group_arn = aws_lb_target_group.ecs_backend.arn 
  }

  condition {
    host_header {
      values = [ var.backend_url ]
    }
  }
}
