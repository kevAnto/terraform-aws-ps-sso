# Search Heads
resource "aws_instance" "searchHead" {
  count                  = var.searchHeadCount
  ami                    = var.splunkAmi
  instance_type          = var.searchHeadInstanceType
  subnet_id              = element(var.publicSubnetIds, count.index % length(var.publicSubnetIds))
  vpc_security_group_ids = [var.securityGroupId]
  #key_name               = var.keyName != "" ? var.keyName : null
  iam_instance_profile   = var.instanceProfileName

  root_block_device {
    volume_size = var.searchHeadVolumeSize
    volume_type = "gp3"
  }
  
  user_data = var.useCustomUserData ? var.customUserData : <<-EOF
    ${local.userData}
    # Call the Splunk installation script
    ${file(var.scriptPath)}
    EOF

  tags = merge(
    var.commonTags,
    {
      Name = "${var.namePrefix}-sh-${count.index + 1}"
      Role = "search-head"
    }
  )

  depends_on = [null_resource.scriptPermissions]
}