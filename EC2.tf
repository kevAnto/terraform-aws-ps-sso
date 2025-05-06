resource "aws_instance" "splunk_search_head" {
  count         = 3
  ami           = var.splunk_ami
  instance_type = var.search_head_instance_type
  subnet_id     = element(aws_subnet.public_subnets[*].id, count.index % length(aws_subnet.public_subnets))
  vpc_security_group_ids = [aws_security_group.splunk_sg.id]
  key_name      = var.key_name
  iam_instance_profile = aws_iam_instance_profile.ssm_instance_profile.name
  #associate_public_ip_address = true

  root_block_device {
    volume_size = 100
    volume_type = "gp3"
  }
  
  user_data = file("splunk-sh.sh")

  tags = {
    Name        = "splunk-sh-${count.index + 1}"
    Environment = var.environment
    Role        = "search-head"
  }

  depends_on = [aws_internet_gateway.igw, null_resource.script_permissions]
}

locals {
  user_data_common = <<-EOF
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

resource "aws_instance" "splunk_indexer" {
  count         = 4
  ami           = var.splunk_ami
  instance_type = var.indexer_instance_type
  subnet_id     = element(aws_subnet.private_subnets[*].id, count.index % length(aws_subnet.private_subnets))
  vpc_security_group_ids = [aws_security_group.splunk_sg.id]
  key_name      = var.key_name
  iam_instance_profile = aws_iam_instance_profile.ssm_instance_profile.name
  #associate_public_ip_address = true

  root_block_device {
    volume_size = 200
    volume_type = "gp3"
  }

  user_data = <<-EOF
${local.user_data_common}
# Rest of your Splunk search head configuration
${file("splunk-sh.sh")}
EOF

  tags = {
    Name        = "splunk-idx-${count.index + 1}"
    Environment = var.environment
    Role        = "indexer"
  }
}

resource "aws_instance" "splunk_cluster_manager" {
  ami           = var.splunk_ami
  instance_type = var.cluster_manager_instance_type
  subnet_id     = aws_subnet.private_subnets[0].id
  vpc_security_group_ids = [aws_security_group.splunk_sg.id]
  key_name      = var.key_name
  iam_instance_profile = aws_iam_instance_profile.ssm_instance_profile.name
  #associate_public_ip_address = true

  root_block_device {
    volume_size = 100
    volume_type = "gp3"
  }

  user_data = <<-EOF
    #!/bin/bash
    echo "Setting up Splunk Cluster Manager"
    # Your Splunk configuration commands here
  EOF

  tags = {
    Name        = "splunk-cm"
    Environment = var.environment
    Role        = "cluster-manager"
  }
}

resource "aws_instance" "splunk_monitoring_console" {
  ami           = var.splunk_ami
  instance_type = var.monitoring_console_instance_type
  subnet_id     = aws_subnet.private_subnets[0].id
  vpc_security_group_ids = [aws_security_group.splunk_sg.id]
  key_name      = var.key_name
  iam_instance_profile = aws_iam_instance_profile.ssm_instance_profile.name
  #associate_public_ip_address = true

  root_block_device {
    volume_size = 100
    volume_type = "gp3"
  }

  user_data = <<-EOF
    #!/bin/bash
    echo "Setting up Splunk Monitoring Console"
    # Your Splunk configuration commands here
  EOF

  tags = {
    Name        = "splunk-mc"
    Environment = var.environment
    Role        = "monitoring-console"
  }
}

resource "aws_instance" "splunk_license_manager" {
  ami                         = var.splunk_ami
  instance_type               = var.license_manager_instance_type
  subnet_id                   = aws_subnet.private_subnets[0].id
  vpc_security_group_ids      = [aws_security_group.splunk_sg.id]
  key_name                    = var.key_name
  iam_instance_profile        = aws_iam_instance_profile.ssm_instance_profile.name
  #associate_public_ip_address = true

  root_block_device {
    volume_size = 100
    volume_type = "gp3"
  }
  tags = {
    Name        = "splunk-lm"
    Environment = var.environment
    Role        = "license-manager"
  }
}