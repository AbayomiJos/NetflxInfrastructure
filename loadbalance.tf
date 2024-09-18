# Application Load Balancer
resource "aws_lb" "netflix_alb" {
  name               = "netflix-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.netflix_alb_sg.id]
  subnets            = [
    aws_subnet.netflix_public_subnet_1.id,
    aws_subnet.netflix_public_subnet_2.id
  ]
  enable_deletion_protection = false
  enable_cross_zone_load_balancing = true
  idle_timeout = 400
  drop_invalid_header_fields = true
  enable_http2 = true

  tags = {
    Name = "netflix-alb"
  }
}

# ALB Target Group
resource "aws_lb_target_group" "netflix_target_group" {
  name     = "netflix-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.netflix_vpc.id

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 3
  }

  tags = {
    Name = "netflix-target-group"
  }
}

# ALB Listener
resource "aws_lb_listener" "netflix_alb_listener" {
  load_balancer_arn = aws_lb.netflix_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.netflix_target_group.arn
  }
}




