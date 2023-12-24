# bootstrap

Terraform module to provision the following resources required for Terraform boostrapping:
- [`S3`](https://docs.aws.amazon.com/AmazonS3/latest/userguide/Welcome.html) buckets in new AWS environment for various purposes - CloudTrail logging and Terraform state storing
- [`DynamoDB`](https://aws.amazon.com/dynamodb/) table for Terraform state locking mechanism
- [`CloudTrail`](https://docs.aws.amazon.com/awscloudtrail/latest/userguide/cloudtrail-user-guide.html) service


## Usage

Include this repository as a module in your existing terraform code:

```hcl
module "bootstrap" {
  source = "git@github.com:marinkovicpetar/vortexwest-terraform/modules/bootstrap"

  project_name = var.project_name
  environment  = var.environment
  account_id   = var.account_id
  
}
```

## Resources

| Name | Type |
|------|------|
| [aws_cloudtrail.cloudtrail](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudtrail) | resource |
| [aws_dynamodb_table.terraform](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dynamodb_table) | resource |
| [aws_s3_bucket.cloudtrail](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket.terraform](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_policy.cloudtrail](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy) | resource |
| [aws_s3_bucket_public_access_block.cloudtrail](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block) | resource |
| [aws_s3_bucket_public_access_block.terraform](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block) | resource |
| [aws_s3_bucket_server_side_encryption_configuration.cloudtrail](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_server_side_encryption_configuration) | resource |
| [aws_s3_bucket_server_side_encryption_configuration.terraform](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_server_side_encryption_configuration) | resource |
| [aws_s3_bucket_versioning.terraform](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_versioning) | resource |
| [aws_iam_policy_document.cloudtrail](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_account_id"></a> [account\_id](#input\_account\_id) | AWS account ID in which you will provision S3 buckets | `string` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment in which you will provision S3 buckets | `string` | n/a | yes |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | Name of the project | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dynamodb_terraform_arn"></a> [dynamodb\_terraform\_arn](#output\_dynamodb\_terraform\_arn) | The ARN of the DynamoDB table for Terraform locking |
| <a name="output_dynamodb_terraform_id"></a> [dynamodb\_terraform\_id](#output\_dynamodb\_terraform\_id) | The name of the DynamoDB table for Terraform locking |
| <a name="output_s3_cloudtrail_arn"></a> [s3\_cloudtrail\_arn](#output\_s3\_cloudtrail\_arn) | The ARN of the CloudTrail S3 bucket. Will be of format arn:aws:s3:::bucketname |
| <a name="output_s3_cloudtrail_bucket_domain_name"></a> [s3\_cloudtrail\_bucket\_domain\_name](#output\_s3\_cloudtrail\_bucket\_domain\_name) | The bucket domain name of the CloudTrail S3 bucket. Will be of format bucketname.s3.amazonaws.com |
| <a name="output_s3_cloudtrail_id"></a> [s3\_cloudtrail\_id](#output\_s3\_cloudtrail\_id) | The name of the CloudTrail S3 bucket |
| <a name="output_s3_terraform_arn"></a> [s3\_terraform\_arn](#output\_s3\_terraform\_arn) | The ARN of the Terraform S3 bucket. Will be of format arn:aws:s3:::bucketname |
| <a name="output_s3_terraform_bucket_domain_name"></a> [s3\_terraform\_bucket\_domain\_name](#output\_s3\_terraform\_bucket\_domain\_name) | The bucket domain name of the Terraform S3 bucket. Will be of format bucketname.s3.amazonaws.com |
| <a name="output_s3_terraform_id"></a> [s3\_terraform\_id](#output\_s3\_terraform\_id) | The name of the Terraform S3 bucket |