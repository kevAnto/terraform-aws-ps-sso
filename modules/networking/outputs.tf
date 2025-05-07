output "vpcId" {
  description = "The ID of the VPC"
  value       = aws_vpc.splunkVpc.id
}

output "publicSubnetIds" {
  description = "List of public subnet IDs"
  value       = aws_subnet.publicSubnets[*].id
}

output "privateSubnetIds" {
  description = "List of private subnet IDs"
  value       = aws_subnet.privateSubnets[*].id
}

output "vpcCidr" {
  description = "The CIDR block of the VPC"
  value       = aws_vpc.splunkVpc.cidr_block
}

output "natGatewayId" {
  description = "The ID of the NAT Gateway"
  value       = aws_nat_gateway.natGateway.id
}

output "internetGatewayId" {
  description = "The ID of the Internet Gateway"
  value       = aws_internet_gateway.igw.id
}