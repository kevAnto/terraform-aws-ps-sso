resource "aws_security_group" "splunk_sg" {
  name        = "splunk-sg"
  description = "Security group for Splunk instances"
  vpc_id      = aws_vpc.splunk_vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "HTTP access"
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "HTTPS access"
  }

  ingress {
    from_port   = 8000
    to_port     = 8000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Splunk Web UI"
  }

  ingress {
    from_port   = 8089
    to_port     = 8089
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Splunk Management port"
  }

  ingress {
    from_port   = 8191
    to_port     = 8191
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.splunk_vpc.cidr_block]
    description = "Cluster replication"
  }

  ingress {
    from_port   = 9887
    to_port     = 9887
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.splunk_vpc.cidr_block]
    description = "App server feedback"
  }

  ingress {
    from_port   = 9997
    to_port     = 9997
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.splunk_vpc.cidr_block]
    description = "Data forwarding"
  }

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [aws_vpc.splunk_vpc.cidr_block]
    description = "Internal VPC communication"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "All outbound traffic"
  }

  tags = {
    Name        = "splunk-sg"
    Environment = var.environment
  }
}

resource "aws_iam_role" "ssm_role" {
  name = "splunk-ssm-role"
  
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}