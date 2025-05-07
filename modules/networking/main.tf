/**
 * # Networking Module
 * This module handles the creation of VPC, subnets, route tables, 
 * internet gateway, NAT gateway and related networking components
 */

# VPC Configuration
resource "aws_vpc" "splunkVpc" {
  cidr_block           = var.vpcCidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(
    var.commonTags,
    {
      Name = "${var.namePrefix}-vpc"
    }
  )
}

# Create an Elastic IP for NAT Gateway
resource "aws_eip" "natEip" {
  tags = merge(
    var.commonTags,
    {
      Name = "${var.namePrefix}-nat-eip"
    }
  )
}

# Create Public Subnets
resource "aws_subnet" "publicSubnets" {
  count                   = length(var.publicSubnetCidrs)
  vpc_id                  = aws_vpc.splunkVpc.id
  cidr_block              = var.publicSubnetCidrs[count.index]
  availability_zone       = element(var.availabilityZones, count.index)
  map_public_ip_on_launch = true

  tags = merge(
    var.commonTags,
    {
      Name = "${var.namePrefix}-public-subnet-${count.index + 1}"
    }
  )
}

# Create Private Subnets
resource "aws_subnet" "privateSubnets" {
  count             = length(var.privateSubnetCidrs)
  vpc_id            = aws_vpc.splunkVpc.id
  cidr_block        = var.privateSubnetCidrs[count.index]
  availability_zone = element(var.availabilityZones, count.index)

  tags = merge(
    var.commonTags,
    {
      Name = "${var.namePrefix}-private-subnet-${count.index + 1}"
    }
  )
}

# Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.splunkVpc.id

  tags = merge(
    var.commonTags,
    {
      Name = "${var.namePrefix}-igw"
    }
  )
}

# NAT Gateway
resource "aws_nat_gateway" "natGateway" {
  allocation_id = aws_eip.natEip.id
  subnet_id     = aws_subnet.publicSubnets[0].id

  tags = merge(
    var.commonTags,
    {
      Name = "${var.namePrefix}-nat-gateway"
    }
  )

  depends_on = [aws_internet_gateway.igw]
}

# Public Route Table
resource "aws_route_table" "publicRt" {
  vpc_id = aws_vpc.splunkVpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = merge(
    var.commonTags,
    {
      Name = "${var.namePrefix}-public-rt"
    }
  )
}

# Public Route Table Association
resource "aws_route_table_association" "public" {
  count          = length(var.publicSubnetCidrs)
  subnet_id      = aws_subnet.publicSubnets[count.index].id
  route_table_id = aws_route_table.publicRt.id
}

# Private Route Table
resource "aws_route_table" "privateRt" {
  vpc_id = aws_vpc.splunkVpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.natGateway.id
  }

  tags = merge(
    var.commonTags,
    {
      Name = "${var.namePrefix}-private-rt"
    }
  )
}

# Private Route Table Association
resource "aws_route_table_association" "private" {
  count          = length(var.privateSubnetCidrs)
  subnet_id      = aws_subnet.privateSubnets[count.index].id
  route_table_id = aws_route_table.privateRt.id
}

# VPC Endpoints for SSM
resource "aws_vpc_endpoint" "ssm" {
  vpc_id              = aws_vpc.splunkVpc.id
  service_name        = "com.amazonaws.${var.region}.ssm"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = aws_subnet.privateSubnets[*].id
  security_group_ids  = [var.securityGroupId]
  private_dns_enabled = true

  tags = merge(
    var.commonTags,
    {
      Name = "${var.namePrefix}-ssm-endpoint"
    }
  )
}

resource "aws_vpc_endpoint" "ssmmessages" {
  vpc_id              = aws_vpc.splunkVpc.id
  service_name        = "com.amazonaws.${var.region}.ssmmessages"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = aws_subnet.privateSubnets[*].id
  security_group_ids  = [var.securityGroupId]
  private_dns_enabled = true

  tags = merge(
    var.commonTags,
    {
      Name = "${var.namePrefix}-ssmmessages-endpoint"
    }
  )
}

resource "aws_vpc_endpoint" "ec2messages" {
  vpc_id              = aws_vpc.splunkVpc.id
  service_name        = "com.amazonaws.${var.region}.ec2messages"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = aws_subnet.privateSubnets[*].id
  security_group_ids  = [var.securityGroupId]
  private_dns_enabled = true

  tags = merge(
    var.commonTags,
    {
      Name = "${var.namePrefix}-ec2messages-endpoint"
    }
  )
}