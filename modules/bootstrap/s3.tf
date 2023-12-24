# Terraform S3 bucket
resource "aws_s3_bucket" "terraform" {
  bucket = format("%s-%s-terraform", var.project_name, var.environment)

#  lifecycle {
#    prevent_destroy = true
#  }  

  tags = {
    Environment = var.environment
  }
}

resource "aws_s3_bucket_versioning" "terraform" {
  bucket = aws_s3_bucket.terraform.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "terraform" {
  bucket = aws_s3_bucket.terraform.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "terraform" {
  bucket = aws_s3_bucket.terraform.id

  block_public_acls       = true
  block_public_policy     = true
  restrict_public_buckets = true
  ignore_public_acls      = true
}

# CloudTrail S3 bucket
resource "aws_s3_bucket" "cloudtrail" {
  bucket = format("%s-%s-cloudtrail", var.project_name, var.environment)

#  lifecycle {
#    prevent_destroy = true
#  }

  tags = {
    Environment = var.environment
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "cloudtrail" {
  bucket = aws_s3_bucket.cloudtrail.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "cloudtrail" {
  bucket = aws_s3_bucket.cloudtrail.id

  block_public_acls       = true
  block_public_policy     = true
  restrict_public_buckets = true
  ignore_public_acls      = true
}

data "aws_iam_policy_document" "cloudtrail" {

  statement {
    sid    = "AWSCloudTrailAclCheck"
    effect = "Allow"

    resources = [
      aws_s3_bucket.cloudtrail.arn
    ]

    actions = [
      "s3:GetBucketAcl"
    ]

    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }
  }

  statement {
    sid    = "AWSCloudTrailWrite"
    effect = "Allow"

    resources = [
      "${aws_s3_bucket.cloudtrail.arn}/AWSLogs/${var.account_id}/*",
    ]

    actions = [
      "s3:PutObject"
    ]

    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-acl"

      values = [
        "bucket-owner-full-control"
      ]
    }

    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }
  }
}

resource "aws_s3_bucket_policy" "cloudtrail" {
  bucket = aws_s3_bucket.cloudtrail.id
  policy = data.aws_iam_policy_document.cloudtrail.json
}
