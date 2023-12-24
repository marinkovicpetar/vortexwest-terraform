# Global variables
variable "project_name" {
  type        = string
  description = "Name of the project"
}

variable "environment" {
  type        = string
  description = "Environment in which you will provision S3 buckets"
}

variable "account_id" {
  type        = string
  description = "AWS account ID in which you will provision S3 buckets"
}
