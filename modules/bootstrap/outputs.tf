# Terraform S3 bucket outputs
output "s3_terraform_id" {
  value       = aws_s3_bucket.terraform.id
  description = "The name of the Terraform S3 bucket"
}

output "s3_terraform_arn" {
  value       = aws_s3_bucket.terraform.arn
  description = "The ARN of the Terraform S3 bucket. Will be of format arn:aws:s3:::bucketname"
}

output "s3_terraform_bucket_domain_name" {
  value       = aws_s3_bucket.terraform.bucket_domain_name
  description = "The bucket domain name of the Terraform S3 bucket. Will be of format bucketname.s3.amazonaws.com"
}

# CloudTrail S3 bucket outputs
output "s3_cloudtrail_id" {
  value       = aws_s3_bucket.cloudtrail.id
  description = "The name of the CloudTrail S3 bucket"
}

output "s3_cloudtrail_arn" {
  value       = aws_s3_bucket.cloudtrail.arn
  description = "The ARN of the CloudTrail S3 bucket. Will be of format arn:aws:s3:::bucketname"
}

output "s3_cloudtrail_bucket_domain_name" {
  value       = aws_s3_bucket.cloudtrail.bucket_domain_name
  description = "The bucket domain name of the CloudTrail S3 bucket. Will be of format bucketname.s3.amazonaws.com"
}

# DynamoDB outputs
output "dynamodb_terraform_id" {
  value       = aws_dynamodb_table.terraform.id
  description = "The name of the DynamoDB table for Terraform locking"
}

output "dynamodb_terraform_arn" {
  value       = aws_dynamodb_table.terraform.arn
  description = "The ARN of the DynamoDB table for Terraform locking"
}
