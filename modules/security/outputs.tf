output "securityGroupId" {
  description = "The ID of the security group for Splunk instances"
  value       = aws_security_group.splunkSg.id
}

output "iamRoleArn" {
  description = "The ARN of the IAM role for SSM"
  value       = aws_iam_role.ssmRole.arn
}

output "instanceProfileName" {
  description = "The name of the instance profile for Splunk instances"
  value       = aws_iam_instance_profile.ssmInstanceProfile.name
}

output "instanceProfileArn" {
  description = "The ARN of the instance profile for Splunk instances"
  value       = aws_iam_instance_profile.ssmInstanceProfile.arn
}