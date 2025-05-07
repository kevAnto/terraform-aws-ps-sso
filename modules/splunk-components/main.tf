/**
 * # Splunk Components Module
 * This module handles the creation of all Splunk components, including search heads,
 * indexers, cluster manager, license manager, and monitoring console.
 */

# Common setup for scripts
resource "null_resource" "scriptPermissions" {
  provisioner "local-exec" {
    command = "chmod +x ${var.scriptPath}"
  }
}

locals {
  userData = <<-EOF
    #!/bin/bash
    # Update system and install SSM agent
    yum update -y
    yum install -y amazon-ssm-agent
    systemctl enable amazon-ssm-agent
    systemctl start amazon-ssm-agent

    # Check SSM agent status
    systemctl status amazon-ssm-agent
EOF
}