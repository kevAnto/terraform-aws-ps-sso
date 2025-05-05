
output "search_head_lb_dns" {
  description = "DNS name of the search head load balancer"
  value       = aws_lb.splunk_sh_lb.dns_name
}

output "cluster_manager_private_ip" {
  description = "Private IP of the cluster manager"
  value       = aws_instance.splunk_cluster_manager.private_ip
}

output "indexer_private_ips" {
  description = "Private IPs of the indexers"
  value       = aws_instance.splunk_indexer[*].private_ip
}

output "search_head_private_ips" {
  description = "Private IPs of the search heads"
  value       = aws_instance.splunk_search_head[*].private_ip
}