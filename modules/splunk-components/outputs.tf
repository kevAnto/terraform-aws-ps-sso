output "searchHeadIds" {
  description = "IDs of the search head instances"
  value       = aws_instance.searchHead[*].id
}

output "searchHeadPublicIps" {
  description = "Public IPs of the search head instances"
  value       = aws_instance.searchHead[*].public_ip
}

output "searchHeadPrivateIps" {
  description = "Private IPs of the search head instances"
  value       = aws_instance.searchHead[*].private_ip
}

output "indexerIds" {
  description = "IDs of the indexer instances"
  value       = aws_instance.indexer[*].id
}

output "indexerPrivateIps" {
  description = "Private IPs of the indexer instances"
  value       = aws_instance.indexer[*].private_ip
}

output "clusterManagerId" {
  description = "ID of the cluster manager instance"
  value       = aws_instance.clusterManager.id
}

output "clusterManagerPrivateIp" {
  description = "Private IP of the cluster manager instance"
  value       = aws_instance.clusterManager.private_ip
}

output "licenseManagerId" {
  description = "ID of the license manager instance"
  value       = aws_instance.licenseManager.id
}

output "licenseManagerPrivateIp" {
  description = "Private IP of the license manager instance"
  value       = aws_instance.licenseManager.private_ip
}

output "monitoringConsoleId" {
  description = "ID of the monitoring console instance"
  value       = aws_instance.monitoringConsole.id
}

output "monitoringConsolePrivateIp" {
  description = "Private IP of the monitoring console instance"
  value       = aws_instance.monitoringConsole.private_ip
}