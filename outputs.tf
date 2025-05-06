# Outputs
output "search_head_public_ips" {
  value = aws_instance.splunk_search_head[*].public_ip
}

output "indexer_private_ips" {
  value = aws_instance.splunk_indexer[*].private_ip
}

output "cluster_manager_private_ip" {
  value = aws_instance.splunk_cluster_manager.private_ip
}
output "license_manager_private_ip" {
  value = aws_instance.splunk_license_manager.private_ip
}

output "monitoring_console_private_ip" {
  value = aws_instance.splunk_monitoring_console.private_ip
}

output "load_balancer_dns" {
  value = aws_lb.splunk_sh_lb.dns_name
}