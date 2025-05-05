
resource "aws_s3_bucket" "splunk_smartstore" {
  bucket = "splunk-smartstore-${var.environment}"
  region = "us-east-1"

  tags = {
    Name        = "splunk-smartstore"
    Environment = var.environment
  }
}

resource "aws_s3_bucket_versioning" "splunk_smartstore_versioning" {
  bucket = aws_s3_bucket.splunk_smartstore.id
  
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "splunk_smartstore_encryption" {
  bucket = aws_s3_bucket.splunk_smartstore.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}