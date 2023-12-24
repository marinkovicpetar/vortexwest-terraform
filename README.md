# vortexwest-terraform

Terraform module to provision the AWS resources required for VortexWest deployment of [frontend](https://hub.docker.com/layers/micic/vortexwest/frontend/images/sha256-05dbbe40847058bf5888cc3b5d902fe93d4e5a7508ea82597cbd711d5c7f3993?context=explore) and [backend](https://hub.docker.com/layers/micic/vortexwest/backend/images/sha256-4678c18e63293c04bbc18543c8d465f239a42705d55ecc969aeb6ae882762746?context=explore) Docker images in ECS cluster:
- [`VPC`](https://docs.aws.amazon.com/vpc/) with 3 AZ, public, private and database subnets, one NAT Gateway per VPC, provisioned by [`OSS Terraform module`](https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/latest)
- [`RDS`](https://docs.aws.amazon.com/rds/) with latest PostgreSQL 16.1, provisioned by [`OSS Terraform module`](https://registry.terraform.io/modules/terraform-aws-modules/rds/aws/latest)
- [`ECS`](https://docs.aws.amazon.com/ecs/) resources - ECS cluster with ASG and EC2, ECS tasks and ECS services for both `frontend` and `backend` services
- [`ALB`](https://docs.aws.amazon.com/elasticloadbalancing/latest/application/introduction.html) with one listener for `HTTP:80` port and Target groups for both `frontend` and `backend` services
- [`CloudWatch Log Groups`](https://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/Working-with-log-groups-and-streams.html) for both `frontend` and `backend` services
- various [`IAM`](https://docs.aws.amazon.com/iam/) entities, such as `IAM role` and `IAM Instance Profile` for ASG EC2 instances, `IAM role` and `IAM policy` for `frontend` and `backend` ECS tasks to be used as execution roles
- [`Secrets Manager`]() entry to store RDS credentials
- various [`Security Groups`](https://docs.aws.amazon.com/vpc/latest/userguide/vpc-security-groups.html) for ALB, EC2 instances in ASG, RDS, provisioned by [`OSS Terraform module`](https://registry.terraform.io/modules/terraform-aws-modules/security-group/aws/latest)


## Usage

Include this repository as a module in your existing terraform code:

```hcl
module "vortexwest" {
  source = "git@github.com:marinkovicpetar/vortexwest-terraform"

  project_name = var.project_name
  environment  = var.environment
  account_id   = var.account_id

  deploy_new_account = true

  frontend_url = var.frontend_url
  backend_url  = var.backend_url
  
}
```

## Requirements

1. AWS account with valid credentials (configured with variable `profile`). If the account is new, and not set up for usage with Terraform, `deploy_new_account` variable should be set to `true` (defaults to `false`). Also, you should know the `account_id` of your AWS account that you will use.
2. Valid URLs for both `frontend` and `backend` services, as ALB is performing host-based routing. Sending anything else other than correct URLs to ALB would get you `HTTP 400 Request not valid` response
3. Once you're up and running, move the [Terraform state]() from local machine to S3 bucket you created by changing `state.tf` file, to look something like this

```hcl
terraform {
  required_version = "1.6.6"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.31.0"
    }
  }

  backend "s3" {
    region         = "us-east-1"
    profile        = "<var.profile>"
    bucket         = "<var.project_name-var.environment-terraform>"
    dynamodb_table = "<var.project_name-var.environment-terraform-lock>"
    key            = "terraform.tfstate"
    encrypt        = true
  }    
}
```
and tun `terraform init` and accept migration of state to S3 bucket


## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |
| <a name="provider_random"></a> [random](#provider\_random) | n/a |
| <a name="provider_template"></a> [template](#provider\_template) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_bootstrap"></a> [bootstrap](#module\_bootstrap) | ./modules/bootstrap/ | n/a |
| <a name="module_rds"></a> [rds](#module\_rds) | terraform-aws-modules/rds/aws | 6.3.0 |
| <a name="module_sg_alb"></a> [sg\_alb](#module\_sg\_alb) | terraform-aws-modules/security-group/aws | 5.1.0 |
| <a name="module_sg_asg_ecs"></a> [sg\_asg\_ecs](#module\_sg\_asg\_ecs) | terraform-aws-modules/security-group/aws | 5.1.0 |
| <a name="module_sg_rds"></a> [sg\_rds](#module\_sg\_rds) | terraform-aws-modules/security-group/aws | 5.1.0 |
| <a name="module_vpc"></a> [vpc](#module\_vpc) | terraform-aws-modules/vpc/aws | 5.4.0 |

## Resources

| Name | Type |
|------|------|
| [aws_autoscaling_group.asg_ecs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_group) | resource |
| [aws_cloudwatch_log_group.ecs_backend](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_cloudwatch_log_group.ecs_frontend](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_ecs_cluster.ecs_cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_cluster) | resource |
| [aws_ecs_service.ecs_backend](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_service) | resource |
| [aws_ecs_service.ecs_frontend](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_service) | resource |
| [aws_ecs_task_definition.ecs_backend](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_task_definition) | resource |
| [aws_ecs_task_definition.ecs_frontend](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_task_definition) | resource |
| [aws_iam_instance_profile.iam_asg_ecs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_instance_profile) | resource |
| [aws_iam_policy.iam_backend](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.iam_frontend](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.iam_asg_ecs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.iam_backend](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.iam_frontend](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.iam_asg_ecs_service_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.iam_asg_ecs_ssm](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.iam_backend](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.iam_frontend](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_launch_configuration.lc_ecs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/launch_configuration) | resource |
| [aws_lb.alb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb) | resource |
| [aws_lb_listener.alb_listener_80](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener) | resource |
| [aws_lb_listener_rule.ecs_backend_80](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener_rule) | resource |
| [aws_lb_listener_rule.ecs_frontend_80](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener_rule) | resource |
| [aws_lb_target_group.ecs_backend](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group) | resource |
| [aws_lb_target_group.ecs_frontend](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group) | resource |
| [aws_secretsmanager_secret.rds_credentials](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret_version.rds_credentials](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_version) | resource |
| [random_password.rds](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [aws_ami.ecs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) | data source |
| [template_file.asg_ecs](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |
| [template_file.ecs_task_backend](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |
| [template_file.ecs_task_frontend](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_account_id"></a> [account\_id](#input\_account\_id) | AWS account ID in which you will provision S3 buckets | `string` | n/a | yes |
| <a name="input_asg_ecs_desired_capacity"></a> [asg\_ecs\_desired\_capacity](#input\_asg\_ecs\_desired\_capacity) | Desired number of instances in AutoScaling Group of ECS cluster | `number` | `1` | no |
| <a name="input_asg_ecs_max_size"></a> [asg\_ecs\_max\_size](#input\_asg\_ecs\_max\_size) | Maximum number of instances in AutoScaling Group of ECS cluster | `number` | `2` | no |
| <a name="input_asg_ecs_min_size"></a> [asg\_ecs\_min\_size](#input\_asg\_ecs\_min\_size) | Minimum number of instances in AutoScaling Group of ECS cluster | `number` | `1` | no |
| <a name="input_backend_url"></a> [backend\_url](#input\_backend\_url) | URL of the backend ECS service | `string` | n/a | yes |
| <a name="input_default_route"></a> [default\_route](#input\_default\_route) | Default route CIDR | `string` | `"0.0.0.0/0"` | no |
| <a name="input_deploy_new_account"></a> [deploy\_new\_account](#input\_deploy\_new\_account) | Bootstrap new AWS account | `bool` | `false` | no |
| <a name="input_ecs_service_backend_desired_count"></a> [ecs\_service\_backend\_desired\_count](#input\_ecs\_service\_backend\_desired\_count) | Desired number of ECS tasks for the backend ECS service | `number` | `1` | no |
| <a name="input_ecs_service_frontend_desired_count"></a> [ecs\_service\_frontend\_desired\_count](#input\_ecs\_service\_frontend\_desired\_count) | Desired number of ECS tasks for the frontend ECS service | `number` | `1` | no |
| <a name="input_ecs_task_backend_cpu"></a> [ecs\_task\_backend\_cpu](#input\_ecs\_task\_backend\_cpu) | CPU setting in units (1024 = 1 vCPU) for backend ECS task | `number` | `512` | no |
| <a name="input_ecs_task_backend_memory"></a> [ecs\_task\_backend\_memory](#input\_ecs\_task\_backend\_memory) | Memory setting in MB for backend ECS task | `number` | `512` | no |
| <a name="input_ecs_task_frontend_cpu"></a> [ecs\_task\_frontend\_cpu](#input\_ecs\_task\_frontend\_cpu) | CPU setting in units (1024 = 1 vCPU) for frontend ECS task | `number` | `512` | no |
| <a name="input_ecs_task_frontend_memory"></a> [ecs\_task\_frontend\_memory](#input\_ecs\_task\_frontend\_memory) | Memory setting in MB for frontend ECS task | `number` | `512` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment in which you will provision S3 buckets | `string` | n/a | yes |
| <a name="input_frontend_url"></a> [frontend\_url](#input\_frontend\_url) | URL of the frontend ECS service | `string` | n/a | yes |
| <a name="input_lc_ecs_instance_type"></a> [lc\_ecs\_instance\_type](#input\_lc\_ecs\_instance\_type) | Instance type to be provisioned in AutoScaling Group of ECS cluster | `string` | `"t3.medium"` | no |
| <a name="input_lc_ecs_volume_size"></a> [lc\_ecs\_volume\_size](#input\_lc\_ecs\_volume\_size) | Size of EBS volume type to be provisioned in AutoScaling Group of ECS cluster | `number` | `40` | no |
| <a name="input_lc_ecs_volume_type"></a> [lc\_ecs\_volume\_type](#input\_lc\_ecs\_volume\_type) | EBS volume type to be provisioned in AutoScaling Group of ECS cluster | `string` | `"gp3"` | no |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | Name of the project | `string` | n/a | yes |
| <a name="input_rds_allocated_storage"></a> [rds\_allocated\_storage](#input\_rds\_allocated\_storage) | Initial storage size of the RDS instance | `number` | `20` | no |
| <a name="input_rds_backup_retention_period"></a> [rds\_backup\_retention\_period](#input\_rds\_backup\_retention\_period) | How many days backups / snapshots of the RDS instance will be stored | `number` | `7` | no |
| <a name="input_rds_backup_window"></a> [rds\_backup\_window](#input\_rds\_backup\_window) | Time when backup / snapshotting will be performed on the RDS instance every day | `string` | `"02:00-03:00"` | no |
| <a name="input_rds_copy_tags_to_snapshot"></a> [rds\_copy\_tags\_to\_snapshot](#input\_rds\_copy\_tags\_to\_snapshot) | Decide whether tags from the RDS instance will be copied to snapshot metadata | `bool` | `true` | no |
| <a name="input_rds_deletion_protection"></a> [rds\_deletion\_protection](#input\_rds\_deletion\_protection) | Decide whether RDS instance will be protected from accidental deletion | `bool` | `true` | no |
| <a name="input_rds_engine"></a> [rds\_engine](#input\_rds\_engine) | RDS engine | `string` | `"postgres"` | no |
| <a name="input_rds_engine_version"></a> [rds\_engine\_version](#input\_rds\_engine\_version) | RDS engine version | `string` | `"16.1"` | no |
| <a name="input_rds_family"></a> [rds\_family](#input\_rds\_family) | RDS family | `string` | `"postgres16"` | no |
| <a name="input_rds_instance_class"></a> [rds\_instance\_class](#input\_rds\_instance\_class) | Instance type to be provisioned in the RDS | `string` | `"db.t3.micro"` | no |
| <a name="input_rds_maintenance_window"></a> [rds\_maintenance\_window](#input\_rds\_maintenance\_window) | Time when maintenance will be performed on the RDS instance during the week | `string` | `"Mon:03:00-Mon:04:00"` | no |
| <a name="input_rds_max_allocated_storage"></a> [rds\_max\_allocated\_storage](#input\_rds\_max\_allocated\_storage) | Maximum storage size of the RDS instance | `number` | `100` | no |
| <a name="input_rds_port"></a> [rds\_port](#input\_rds\_port) | Port of the RDS instance | `number` | `5432` | no |
| <a name="input_rds_skip_final_snapshot"></a> [rds\_skip\_final\_snapshot](#input\_rds\_skip\_final\_snapshot) | Decide whether you will skip final snapshot when RDS instance is deleted | `bool` | `false` | no |
| <a name="input_rds_username"></a> [rds\_username](#input\_rds\_username) | Master username of the RDS instance | `string` | `"postgres"` | no |
| <a name="input_region"></a> [region](#input\_region) | AWS region where project will be deployed | `string` | `"us-east-1"` | no |
| <a name="input_vpc_cidr"></a> [vpc\_cidr](#input\_vpc\_cidr) | CIDR of the project VPC | `string` | `"10.0.0.0/16"` | no |
| <a name="input_vpc_database_subnets"></a> [vpc\_database\_subnets](#input\_vpc\_database\_subnets) | List of database subnet IP ranges per AZ | `list(string)` | <pre>[<br>  "10.0.7.0/24",<br>  "10.0.8.0/24",<br>  "10.0.9.0/24"<br>]</pre> | no |
| <a name="input_vpc_enable_dns_hostnames"></a> [vpc\_enable\_dns\_hostnames](#input\_vpc\_enable\_dns\_hostnames) | Enable DNS hostnames in project VPC | `bool` | `true` | no |
| <a name="input_vpc_enable_nat_gateway"></a> [vpc\_enable\_nat\_gateway](#input\_vpc\_enable\_nat\_gateway) | Enable NAT Gateway in project VPC | `bool` | `true` | no |
| <a name="input_vpc_one_nat_gateway_per_az"></a> [vpc\_one\_nat\_gateway\_per\_az](#input\_vpc\_one\_nat\_gateway\_per\_az) | Enable NAT Gateway in every AZ of project VPC | `bool` | `false` | no |
| <a name="input_vpc_private_subnets"></a> [vpc\_private\_subnets](#input\_vpc\_private\_subnets) | List of public subnet IP ranges per AZ | `list(string)` | <pre>[<br>  "10.0.0.0/24",<br>  "10.0.1.0/24",<br>  "10.0.3.0/24"<br>]</pre> | no |
| <a name="input_vpc_public_subnets"></a> [vpc\_public\_subnets](#input\_vpc\_public\_subnets) | List of private subnet IP ranges per AZ | `list(string)` | <pre>[<br>  "10.0.4.0/24",<br>  "10.0.5.0/24",<br>  "10.0.6.0/24"<br>]</pre> | no |
| <a name="input_vpc_single_nat_gateway"></a> [vpc\_single\_nat\_gateway](#input\_vpc\_single\_nat\_gateway) | Enable single NAT Gateway in project VPC | `bool` | `true` | no |