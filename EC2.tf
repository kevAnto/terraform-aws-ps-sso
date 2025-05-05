# Splunk Search Heads
resource "aws_instance" "splunk_search_head" {
  count                  = 3
  ami                    = "ami-0c55b159cbfafe1f0" # Replace with appropriate AMI
  instance_type          = "c5.4xlarge"            # 16 CPU, 32GB RAM
  key_name               = "splunk-key"            # Replace with your key name
  vpc_security_group_ids = [aws_security_group.splunk_sg.id]
  subnet_id              = aws_subnet.private_subnets[count.index % length(aws_subnet.private_subnets)].id
  iam_instance_profile   = aws_iam_instance_profile.splunk_profile.name

  depends_on = [
    aws_vpc.splunk_vpc,
    aws_subnet.private,
    aws_security_group.splunk_sg
    # Other resources that must exist first
  ]

  root_block_device {
    volume_type = "gp3"
    volume_size = 100
    encrypted   = true
  }

  ebs_block_device {
    device_name = "/dev/sdb"
    volume_type = "gp3"
    volume_size = 200
    encrypted   = true
  }

  user_data = <<-EOF
              #!/bin/bash
              hostnamectl set-hostname splunk-sh${count.index + 1}
              # Install Splunk commands would go here
              EOF

  tags = {
    Name        = "splunk-sh${count.index + 1}"
    Environment = var.environment
    Role        = "search-head"
  }
}

# Splunk Indexers
resource "aws_instance" "splunk_indexer" {
  count                  = 4
  ami                    = "ami-0c55b159cbfafe1f0" # Replace with appropriate AMI
  instance_type          = "c5.4xlarge"            # 16 CPU, 32GB RAM
  key_name               = "splunk-key"            # Replace with your key name
  vpc_security_group_ids = [aws_security_group.splunk_sg.id]
  subnet_id              = aws_subnet.private_subnets[count.index % length(aws_subnet.private_subnets)].id
  iam_instance_profile   = aws_iam_instance_profile.splunk_profile.name

  root_block_device {
    volume_type = "gp3"
    volume_size = 100
    encrypted   = true
  }

  ebs_block_device {
    device_name = "/dev/sdb"
    volume_type = "gp3"   # SSD for hot/warm storage
    volume_size = 200
    encrypted   = true
  }

  ebs_block_device {
    device_name = "/dev/sdc"
    volume_type = "st1"   # HDD for cold storage
    volume_size = 200
    encrypted   = true
  }

  user_data = <<-EOF
              #!/bin/bash
              hostnamectl set-hostname splunk-idx${count.index + 1}
              # Install Splunk commands would go here
              EOF

  tags = {
    Name        = "splunk-idx${count.index + 1}"
    Environment = var.environment
    Role        = "indexer"
  }
}

# Splunk Management Components
resource "aws_instance" "splunk_cluster_manager" {
  ami                    = "ami-0c55b159cbfafe1f0" # Replace with appropriate AMI
  instance_type          = "c5.2xlarge"            # 8 CPU, 16GB RAM
  key_name               = "splunk-key"            # Replace with your key name
  vpc_security_group_ids = [aws_security_group.splunk_sg.id]
  subnet_id              = aws_subnet.private_subnets[0].id
  iam_instance_profile   = aws_iam_instance_profile.splunk_profile.name
  user_data              = file("user_data_cm.sh")

  root_block_device {
    volume_type = "gp3"
    volume_size = 100
    encrypted   = true
  }

  tags = {
    Name        = "splunk-cm"
    Environment = var.environment
    Role        = "cluster-manager"
  }
}

resource "aws_instance" "splunk_monitoring_console" {
  ami                    = "ami-0c55b159cbfafe1f0" # Replace with appropriate AMI
  instance_type          = "c5.xlarge"             # 4 CPU, 8GB RAM
  key_name               = "splunk-key"            # Replace with your key name
  vpc_security_group_ids = [aws_security_group.splunk_sg.id]
  subnet_id              = aws_subnet.private_subnets[0].id
  iam_instance_profile   = aws_iam_instance_profile.splunk_profile.name
  user_data              = file("user_data_mc.sh")

  root_block_device {
    volume_type = "gp3"
    volume_size = 100
    encrypted   = true
  }

  tags = {
    Name        = "splunk-mc"
    Environment = var.environment
    Role        = "monitoring-console"
  }
}
