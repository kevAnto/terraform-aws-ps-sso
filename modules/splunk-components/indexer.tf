# Indexers
resource "aws_instance" "indexer" {
  count                  = var.indexerCount
  ami                    = var.splunkAmi
  instance_type          = var.indexerInstanceType
  subnet_id              = element(var.privateSubnetIds, count.index % length(var.privateSubnetIds))
  vpc_security_group_ids = [var.securityGroupId]
  #key_name               = var.keyName != "" ? var.keyName : null
  iam_instance_profile   = var.instanceProfileName

  root_block_device {
    volume_size = var.indexerVolumeSize
    volume_type = "gp3"
  }

  user_data = var.useCustomUserData ? var.customUserData : <<-EOF
    ${local.userData}
    # Call the Splunk installation script
    ${file(var.scriptPath)}

    # Configure as indexer
    cat > /opt/splunk/etc/system/local/server.conf << 'SERVERCONF'
    [general]
    serverName = idx-${count.index + 1}

    [clustering]
    mode = peer
    master_uri = https://${aws_instance.clusterManager.private_ip}:8089
    pass4SymmKey = ${var.splunkSecret}

    [license]
    master_uri = https://${aws_instance.licenseManager.private_ip}:8089
    SERVERCONF
    EOF

  tags = merge(
    var.commonTags,
    {
      Name = "${var.namePrefix}-idx-${count.index + 1}"
      Role = "indexer"
    }
  )

  depends_on = [
    null_resource.scriptPermissions, 
    aws_instance.clusterManager,
    aws_instance.licenseManager
  ]
}