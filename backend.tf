terraform {
  backend "s3" {
    bucket = "splunk-smartstore5"
    region = "ca-central-1"
    key    = "Splunk/terraform.tfstate"
  }
}

