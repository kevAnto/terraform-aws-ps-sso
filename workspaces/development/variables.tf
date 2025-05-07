variable "awsRegion" {
  description = "AWS region"
  type        = string
  default     = "ca-central-1"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "development"
}

variable "splunkSecret" {
  description = "Secret used for Splunk component communication"
  type        = string
  sensitive   = true
  default     = "changeme"
}