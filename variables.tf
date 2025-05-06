# Variables
variable "environment" {
  description = "Environment name"
  type        = string
  default     = "prod"
}

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "ca-central-1"
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets"
  type        = list(string)
  default     = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
}

variable "availability_zones" {
  description = "AWS Availability Zones"
  type        = list(string)
  default     = ["ca-central-1a", "ca-central-1b", "ca-central-1d"]
}

variable "splunk_ami" {
  description = "AMI ID for Splunk instances"
  type        = string
  default     = "ami-03afc49e3def9a472" # Replace with actual Splunk AMI
}

variable "search_head_instance_type" {
  description = "Instance type for search heads"
  type        = string
  default     = "t2.micro" #"c5.2xlarge"
}

variable "indexer_instance_type" {
  description = "Instance type for indexers"
  type        = string
  default     = "t2.micro" #"c5.4xlarge"
}

variable "cluster_manager_instance_type" {
  description = "Instance type for cluster manager"
  type        = string
  default     = "t2.micro" #"c5.xlarge"
}

variable "monitoring_console_instance_type" {
  description = "Instance type for monitoring console"
  type        = string
  default     = "t2.micro" #"c5.large"
}

variable "license_manager_instance_type" {
  description = "Instance type for license manager"
  type        = string
  default     = "t2.micro" #"c5.large"
}

#variable "key_name" {
#  description = "SSH key pair name"
#  type        = string
#  default     = "splunk-key" # Replace with your actual key pair name
#}
