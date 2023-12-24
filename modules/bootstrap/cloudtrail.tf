# CloudTrail service settings
resource "aws_cloudtrail" "cloudtrail" {
  name                          = format("%s-%s-cloudtrail", var.project_name, var.environment)
  s3_bucket_name                = aws_s3_bucket.cloudtrail.id
  include_global_service_events = true 
  is_multi_region_trail         = true
}
