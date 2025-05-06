terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.52.0"
    }
  }
}

provider "aws" {
  region = "ca-central-1" 
}
provider "aws" {
  alias  = "central1"
  region = "ca-central-1"
}