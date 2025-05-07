variable "namePrefix" {
  description = "Prefix to be used for resource names"
  type        = string
  default     = "splunk"
}

variable "vpcId" {
  description = "ID of the VPC"
  type        = string
}

variable "vpcCidr" {
  description = "CIDR block of the VPC"
  type        = string
}

variable "commonTags" {
  description = "Common tags to be applied to all resources"
  type        = map(string)
  default     = {}
}