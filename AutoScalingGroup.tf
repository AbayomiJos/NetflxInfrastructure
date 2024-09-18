# Auto Scaling Group for Private Instances
resource "aws_launch_configuration" "netflix_private_lc" {
  name          = "netflix-private-lc"
  image_id      = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name
  security_groups = [aws_security_group.netflix_private_sg.id]
  associate_public_ip_address = false

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "netflix_private_asg" {
  launch_configuration = aws_launch_configuration.netflix_private_lc.id
  vpc_zone_identifier = [
    aws_subnet.netflix_private_subnet_1.id,
    aws_subnet.netflix_private_subnet_2.id
  ]
  min_size = 2
  max_size = 20
  desired_capacity = 2

  tag {
    key                 = "Name"
    value               = "netflix-private-instance"
    propagate_at_launch = true
  }

  # Attach the ASG to the target group
  target_group_arns = [aws_lb_target_group.netflix_target_group.arn]
}

