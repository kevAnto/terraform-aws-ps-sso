variable "namePrefix" {
  description = "Prefix to be used for resource names"
  type        = string
  default     = "splunk"
}

variable "vpcCidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "publicSubnetCidrs" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "privateSubnetCidrs" {
  description = "CIDR blocks for private subnets"
  type        = list(string)
  default     = ["10.0.4.0/24", "10.0.5.0/24"]
}

variable "availabilityZones" {
  description = "AWS Availability Zones"
  type        = list(string)
}

variable "region" {
  description = "AWS region"
  type        = string
}

variable "commonTags" {
  description = "Common tags to be applied to all resources"
  type        = map(string)
  default     = {}
}

variable "securityGroupId" {
  description = "Security group ID to attach to VPC endpoints"
  type        = string
}