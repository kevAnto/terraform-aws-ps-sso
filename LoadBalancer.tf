
resource "aws_lb" "splunk_sh_lb" {
  name               = "splunk-sh-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.splunk_sg.id]
  subnets            = aws_subnet.public_subnets[*].id

  tags = {
    Name        = "splunk-sh-lb"
    Environment = var.environment
  }
}

resource "aws_lb_target_group" "splunk_sh_tg" {
  name     = "splunk-sh-tg"
  port     = 8000
  protocol = "HTTP"
  vpc_id   = aws_vpc.splunk_vpc.id

  health_check {
    path                = "/en-US/account/login"
    protocol            = "HTTP"
    port                = "8000"
    healthy_threshold   = 3
    unhealthy_threshold = 3
    timeout             = 5
    interval            = 30
  }

  tags = {
    Name        = "splunk-sh-tg"
    Environment = var.environment
  }
}

resource "aws_lb_listener" "splunk_sh_listener" {
  load_balancer_arn = aws_lb.splunk_sh_lb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  ##certificate_arn   = "arn:aws:acm:us-east-1:123456789012:certificate/example-cert-arn" # Replace with your cert ARN

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.splunk_sh_tg.arn
  }
}

resource "aws_lb_target_group_attachment" "splunk_sh_tg_attachment" {
  count            = length(aws_instance.splunk_search_head)
  target_group_arn = aws_lb_target_group.splunk_sh_tg.arn
  target_id        = aws_instance.splunk_search_head[count.index].id
  port             = 8000
}
