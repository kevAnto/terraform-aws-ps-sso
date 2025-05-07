variable "namePrefix" {
  description = "Prefix to be used for resource names"
  type        = string
  default     = "splunk"
}

variable "vpcId" {
  description = "ID of the VPC"
  type        = string
}

variable "publicSubnetIds" {
  description = "List of public subnet IDs"
  type        = list(string)
}

variable "targetInstanceIds" {
  description = "List of instance IDs to register with the target group"
  type        = list(string)
}

variable "targetPort" {
  description = "Port on which targets receive traffic"
  type        = number
  default     = 8000
}

variable "listenerPort" {
  description = "Port on which the load balancer is listening"
  type        = number
  default     = 443
}

variable "commonTags" {
  description = "Common tags to be applied to all resources"
  type        = map(string)
  default     = {}
}

variable "dependsOn" {
  description = "List of resources that the target group attachments depend on"
  type        = any
  default     = []
}