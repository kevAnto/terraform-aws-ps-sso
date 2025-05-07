/**
 * # Security Module
 * This module handles the creation of security groups, IAM roles and policies
 * required for the Splunk infrastructure
 */

# Security Group for Splunk Instances
resource "aws_security_group" "splunkSg" {
  name        = "${var.namePrefix}-sg"
  description = "Security group for Splunk instances"
  vpc_id      = var.vpcId

  # Web Tier Ports
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

  # Splunk Web UI
  ingress {
    from_port   = 8000
    to_port     = 8000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Splunk Web UI"
  }

  # Splunk Management port
  ingress {
    from_port   = 8089
    to_port     = 8089
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Splunk Management port"
  }

  # Cluster replication port
  ingress {
    from_port   = 8191
    to_port     = 8191
    protocol    = "tcp"
    cidr_blocks = [var.vpcCidr]
    description = "Cluster replication"
  }

  # App server feedback port
  ingress {
    from_port   = 9887
    to_port     = 9887
    protocol    = "tcp"
    cidr_blocks = [var.vpcCidr]
    description = "App server feedback"
  }

  # Forwarding/receiving port
  ingress {
    from_port   = 9997
    to_port     = 9997
    protocol    = "tcp"
    cidr_blocks = [var.vpcCidr]
    description = "Data forwarding"
  }

  # Internal Communications
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.vpcCidr]
    description = "Internal VPC communication"
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "All outbound traffic"
  }

  tags = merge(
    var.commonTags,
    {
      Name = "${var.namePrefix}-sg"
    }
  )
}

# IAM Role for SSM
resource "aws_iam_role" "ssmRole" {
  name = "${var.namePrefix}-ssm-role"
  
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

# Attach SSM policy to the role
resource "aws_iam_role_policy_attachment" "ssmPolicy" {
  role       = aws_iam_role.ssmRole.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# Create instance profile
resource "aws_iam_instance_profile" "ssmInstanceProfile" {
  name = "${var.namePrefix}-ssm-instance-profile"
  role = aws_iam_role.ssmRole.name
}