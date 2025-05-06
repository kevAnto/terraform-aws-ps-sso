# Load Balancer Configuration
resource "aws_lb" "splunk_sh_lb" {
  name               = "splunk-sh-lb"
  internal           = false
  load_balancer_type = "network"
  #security_groups    = [aws_security_group.splunk_sg.id]
  subnets            = aws_subnet.public_subnets[*].id
  provider = aws.central1

  tags = {
    Name        = "splunk-sh-lb"
    Environment = var.environment
  }
}

resource "aws_lb_target_group" "splunk_sh_tg" {
  name        = "splunk-sh-tg"
  port        = 8000
  protocol    = "TCP"
  vpc_id      = aws_vpc.splunk_vpc.id
  target_type = "instance"
  provider = aws.central1 

  health_check {
    protocol            = "TCP"
    port                = 8000
    interval            = 30
    healthy_threshold   = 3
    unhealthy_threshold = 3
  }

  tags = {
    Name        = "splunk-sh-tg"
    Environment = var.environment
  }
}

resource "aws_lb_listener" "splunk_sh_listener" {
  load_balancer_arn = aws_lb.splunk_sh_lb.arn
  port              = "443"
  protocol          = "TCP"
  provider = aws.central1  

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
  provider = aws.central1  
  
  depends_on = [aws_instance.splunk_search_head]
}
