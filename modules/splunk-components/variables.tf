variable "namePrefix" {
  description = "Prefix to be used for resource names"
  type        = string
  default     = "splunk"
}

variable "splunkAmi" {
  description = "AMI ID for Splunk instances"
  type        = string
}

variable "publicSubnetIds" {
  description = "List of public subnet IDs"
  type        = list(string)
}

variable "privateSubnetIds" {
  description = "List of private subnet IDs"
  type        = list(string)
}

variable "securityGroupId" {
  description = "ID of the security group for Splunk instances"
  type        = string
}

variable "instanceProfileName" {
  description = "Name of the instance profile for Splunk instances"
  type        = string
}

variable "scriptPath" {
  description = "Path to the Splunk installation script"
  type        = string
  default     = "scripts/splunk-sh.sh"
}

variable "keyName" {
  description = "SSH key pair name"
  type        = string
  default     = ""
}

variable "commonTags" {
  description = "Common tags to be applied to all resources"
  type        = map(string)
  default     = {}
}

variable "splunkSecret" {
  description = "Secret used for Splunk component communication"
  type        = string
  sensitive   = true
  default     = "changeme"
}

variable "clusterLabel" {
  description = "Label for the Splunk cluster"
  type        = string
  default     = "splunk_cluster"
}

variable "useCustomUserData" {
  description = "Whether to use custom user data script"
  type        = bool
  default     = false
}

variable "customUserData" {
  description = "Custom user data script content"
  type        = string
  default     = ""
}

# Search Head Configuration
variable "searchHeadCount" {
  description = "Number of search heads to deploy"
  type        = number
  default     = 3
}

variable "searchHeadInstanceType" {
  description = "Instance type for search heads"
  type        = string
  default     = "t2.micro"
}

variable "searchHeadVolumeSize" {
  description = "Volume size for search heads in GB"
  type        = number
  default     = 100
}

# Indexer Configuration
variable "indexerCount" {
  description = "Number of indexers to deploy"
  type        = number
  default     = 4
}

variable "indexerInstanceType" {
  description = "Instance type for indexers"
  type        = string
  default     = "t2.micro"
}

variable "indexerVolumeSize" {
  description = "Volume size for indexers in GB"
  type        = number
  default     = 200
}

# Manager Configuration
variable "clusterManagerInstanceType" {
  description = "Instance type for cluster manager"
  type        = string
  default     = "t2.micro"
}

variable "licenseManagerInstanceType" {
  description = "Instance type for license manager"
  type        = string
  default     = "t2.micro"
}

variable "monitoringConsoleInstanceType" {
  description = "Instance type for monitoring console"
  type        = string
  default     = "t2.micro"
}

variable "managerVolumeSize" {
  description = "Volume size for manager instances in GB"
  type        = number
  default     = 100
}