output "vpcId" {
  description = "The ID of the VPC"
  value       = module.networking.vpcId
}

output "searchHeadPublicIps" {
  description = "Public IPs of the search head instances"
  value       = module.splunk_components.searchHeadPublicIps
}

output "indexerPrivateIps" {
  description = "Private IPs of the indexer instances"
  value       = module.splunk_components.indexerPrivateIps
}

output "clusterManagerPrivateIp" {
  description = "Private IP of the cluster manager instance"
  value       = module.splunk_components.clusterManagerPrivateIp
}

output "licenseManagerPrivateIp" {
  description = "Private IP of the license manager instance"
  value       = module.splunk_components.licenseManagerPrivateIp
}

output "monitoringConsolePrivateIp" {
  description = "Private IP of the monitoring console instance"
  value       = module.splunk_components.monitoringConsolePrivateIp
}

output "loadBalancerDns" {
  description = "DNS name of the load balancer"
  value       = module.load_balancer.loadBalancerDns
}