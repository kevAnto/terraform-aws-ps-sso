/**
 * # Load Balancer Module
 * This module handles the creation of the Network Load Balancer for Splunk search heads
 */

# Network Load Balancer
resource "aws_lb" "splunkLb" {
  name               = "${var.namePrefix}-lb"
  internal           = false
  load_balancer_type = "network"
  subnets            = var.publicSubnetIds

  tags = merge(
    var.commonTags,
    {
      Name = "${var.namePrefix}-lb"
    }
  )
}

# Target Group
resource "aws_lb_target_group" "splunkTg" {
  name        = "${var.namePrefix}-tg"
  port        = var.targetPort
  protocol    = "TCP"
  vpc_id      = var.vpcId
  target_type = "instance"

  health_check {
    protocol            = "TCP"
    port                = var.targetPort
    interval            = 30
    healthy_threshold   = 3
    unhealthy_threshold = 3
  }

  tags = merge(
    var.commonTags,
    {
      Name = "${var.namePrefix}-tg"
    }
  )
}

# Listener
resource "aws_lb_listener" "splunkListener" {
  load_balancer_arn = aws_lb.splunkLb.arn
  port              = var.listenerPort
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.splunkTg.arn
  }
}

# Target Group Attachments
resource "aws_lb_target_group_attachment" "splunkTargets" {
  count            = length(var.targetInstanceIds)
  target_group_arn = aws_lb_target_group.splunkTg.arn
  target_id        = var.targetInstanceIds[count.index]
  port             = var.targetPort
  
  depends_on = [var.dependsOn]
}