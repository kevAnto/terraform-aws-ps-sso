Splunk Infrastructure on AWS

This project deploys a complete Splunk Enterprise infrastructure on AWS using Terraform. The architecture includes search heads, indexers, cluster manager, monitoring console, and license manager, all configured with proper networking, security, and AWS Systems Manager (SSM) access.

Architecture Overview

VPC: Dedicated VPC with public and private subnets
Networking: NAT Gateway, Internet Gateway, route tables, security groups
Components:

3 Search Heads (public subnet)
4 Indexers (private subnet)
1 Cluster Manager (private subnet)
1 Monitoring Console (private subnet)
1 License Manager (private subnet)


Load Balancer: Network Load Balancer for search head access
Management: SSM for secure instance access without SSH
Storage: S3 bucket for Splunk SmartStore

Required Resources (Create BEFORE Deployment)
The following resources must be created manually before running Terraform:

1 - S3 Bucket for Terraform State Backend:
        splunk-terraform-state-bucket
        Enable versioning on the bucket

2 - S3 Bucket for Splunk SmartStore:
        Create an S3 bucket named "splunk-smartstore55" in your AWS account
        This will be used for Splunk data storage

3 - SSH Key Pair:
        Create an SSH key pair named "splunk-key" (or modify the variable)