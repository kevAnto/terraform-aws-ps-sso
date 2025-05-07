# Cluster Manager
resource "aws_instance" "clusterManager" {
  ami                    = var.splunkAmi
  instance_type          = var.clusterManagerInstanceType
  subnet_id              = var.privateSubnetIds[0]
  vpc_security_group_ids = [var.securityGroupId]
  #key_name               = var.keyName != "" ? var.keyName : null
  iam_instance_profile   = var.instanceProfileName

  root_block_device {
    volume_size = var.managerVolumeSize
    volume_type = "gp3"
  }

  user_data = var.useCustomUserData ? var.customUserData : <<-EOF
    ${local.userData}
    # Call the Splunk installation script
    ${file(var.scriptPath)}

    # Configure as cluster manager
    cat > /opt/splunk/etc/system/local/server.conf << 'SERVERCONF'
    [general]
    serverName = cluster-manager

    [clustering]
    mode = manager
    pass4SymmKey = ${var.splunkSecret}
    cluster_label = ${var.clusterLabel}

    [license]
    master_uri = https://${aws_instance.licenseManager.private_ip}:8089
    SERVERCONF
    EOF

  tags = merge(
    var.commonTags,
    {
      Name = "${var.namePrefix}-cm"
      Role = "cluster-manager"
    }
  )

  depends_on = [
    null_resource.scriptPermissions,
    aws_instance.licenseManager
  ]
}

# License Manager
resource "aws_instance" "licenseManager" {
  ami                    = var.splunkAmi
  instance_type          = var.licenseManagerInstanceType
  subnet_id              = var.privateSubnetIds[0]
  vpc_security_group_ids = [var.securityGroupId]
  #key_name               = var.keyName != "" ? var.keyName : null
  iam_instance_profile   = var.instanceProfileName

  root_block_device {
    volume_size = var.managerVolumeSize
    volume_type = "gp3"
  }

  user_data = var.useCustomUserData ? var.customUserData : <<-EOF
    ${local.userData}
    # Call the Splunk installation script
    ${file(var.scriptPath)}

    # Configure as license manager
    cat > /opt/splunk/etc/system/local/server.conf << 'SERVERCONF'
    [general]
    serverName = license-manager

    [license]
    master_uri = self
    active_group = Enterprise
    SERVERCONF
    EOF

  tags = merge(
    var.commonTags,
    {
      Name = "${var.namePrefix}-lm"
      Role = "license-manager"
    }
  )

  depends_on = [null_resource.scriptPermissions]
}

# Monitoring Console
resource "aws_instance" "monitoringConsole" {
  ami                    = var.splunkAmi
  instance_type          = var.monitoringConsoleInstanceType
  subnet_id              = var.privateSubnetIds[0]
  vpc_security_group_ids = [var.securityGroupId]
  #key_name               = var.keyName != "" ? var.keyName : null
  iam_instance_profile   = var.instanceProfileName

  root_block_device {
    volume_size = var.managerVolumeSize
    volume_type = "gp3"
  }

  user_data = var.useCustomUserData ? var.customUserData : <<-EOF
    ${local.userData}
    # Call the Splunk installation script
    ${file(var.scriptPath)}

    # Configure as monitoring console
    cat > /opt/splunk/etc/system/local/server.conf << 'SERVERCONF'
    [general]
    serverName = monitoring-console

    [license]
    master_uri = https://${aws_instance.licenseManager.private_ip}:8089
    SERVERCONF
    EOF

  tags = merge(
    var.commonTags,
    {
      Name = "${var.namePrefix}-mc"
      Role = "monitoring-console"
    }
  )

  depends_on = [
    null_resource.scriptPermissions,
    aws_instance.licenseManager
  ]
}