terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.52.0"
    }
  }
  
  backend "s3" {
    bucket = "splunk-smartstore52"
    key    = "splunk-dev/splunk-infrastructure.tfstate"
    region = "ca-central-1"
    encrypt = true
  }
}

provider "aws" {
  region = "ca-central-1"
  
  default_tags {
    tags = {
      Project     = "Splunk"
      ManagedBy   = "Terraform"
      Environment = "development"
    }
  }
}

provider "aws" {
  alias  = "central1"
  region = "ca-central-1"
}