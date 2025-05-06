data "aws_s3_bucket" "splunk_smartstore" {
  bucket = "splunk-smartstore5"
  provider = aws.central1
}

resource "aws_s3_bucket_ownership_controls" "splunk_smartstore" {
  bucket = data.aws_s3_bucket.splunk_smartstore.id
  provider = aws.central1 

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "splunk_smartstore" {
  bucket = data.aws_s3_bucket.splunk_smartstore.id
  acl    = "private"
  provider = aws.central1  
  
  depends_on = [aws_s3_bucket_ownership_controls.splunk_smartstore]
}