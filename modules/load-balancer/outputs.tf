output "loadBalancerDns" {
  description = "DNS name of the load balancer"
  value       = aws_lb.splunkLb.dns_name
}

output "loadBalancerArn" {
  description = "ARN of the load balancer"
  value       = aws_lb.splunkLb.arn
}

output "targetGroupArn" {
  description = "ARN of the target group"
  value       = aws_lb_target_group.splunkTg.arn
}

output "listenerArn" {
  description = "ARN of the listener"
  value       = aws_lb_listener.splunkListener.arn
}