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

variable "region" {
  type        = string
  description = "AWS region where project will be deployed"
  default     = "us-east-1"
}

variable "deploy_new_account" {
  type        = bool
  description = "Bootstrap new AWS account"
  default     = false
}

variable "frontend_url" {
  type        = string
  description = "URL of the frontend ECS service"
}

variable "backend_url" {
  type        = string
  description = "URL of the backend ECS service"  
}

# VPC variables
variable "default_route" {
  type        = string
  description = "Default route CIDR"
  default     = "0.0.0.0/0"
}

variable "vpc_cidr" {
  type        = string
  description = "CIDR of the project VPC"
  default     = "10.0.0.0/16"
}

variable "vpc_enable_dns_hostnames" {
  type        = bool
  description = "Enable DNS hostnames in project VPC"
  default     = true
}

variable "vpc_enable_nat_gateway" {
  type        = bool
  description = "Enable NAT Gateway in project VPC"
  default     = true
}

variable "vpc_single_nat_gateway" {
  type        = bool
  description = "Enable single NAT Gateway in project VPC"
  default     = true
}

variable "vpc_one_nat_gateway_per_az" {
  type        = bool
  description = "Enable NAT Gateway in every AZ of project VPC"
  default     = false
}

variable "vpc_private_subnets" {
  type        = list(string)
  description = "List of public subnet IP ranges per AZ"
  default     = ["10.0.0.0/24", "10.0.1.0/24", "10.0.3.0/24"]
}

variable "vpc_public_subnets" {
  type        = list(string)
  description = "List of private subnet IP ranges per AZ"
  default     = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
}

variable "vpc_database_subnets" {
  type        = list(string)
  description = "List of database subnet IP ranges per AZ"
  default     = ["10.0.7.0/24", "10.0.8.0/24", "10.0.9.0/24"]
}

# ECS Launch Configuration variables
variable "lc_ecs_instance_type" {
  type        = string
  description = "Instance type to be provisioned in AutoScaling Group of ECS cluster"
  default     = "t3.medium"
}

variable "lc_ecs_volume_type" {
  type        = string
  description = "EBS volume type to be provisioned in AutoScaling Group of ECS cluster"
  default     = "gp3" 
}

variable "lc_ecs_volume_size" {
  type        = number
  description = "Size of EBS volume type to be provisioned in AutoScaling Group of ECS cluster"
  default     = 40 
}

# ECS AutoScaling Group variables
variable "asg_ecs_max_size" {
  type        = number
  description = "Maximum number of instances in AutoScaling Group of ECS cluster"
  default     = 2
}

variable "asg_ecs_min_size" {
  type        = number
  description = "Minimum number of instances in AutoScaling Group of ECS cluster"
  default     = 1
}

variable "asg_ecs_desired_capacity" {
  type        = number
  description = "Desired number of instances in AutoScaling Group of ECS cluster"
  default     = 1
}

# RDS variables
variable "rds_engine" {
  type        = string
  description = "RDS engine"
  default     = "postgres"
}

variable "rds_engine_version" {
  type        = string
  description = "RDS engine version"
  default     = "16.1"
}  

variable "rds_family" {
  type        = string
  description = "RDS family"
  default     = "postgres16"
}

variable "rds_port" {
  type        = number
  description = "Port of the RDS instance"
  default     = 5432  
}

variable "rds_instance_class" {
  type        = string
  description = "Instance type to be provisioned in the RDS"
  default     = "db.t3.micro"
}

variable "rds_allocated_storage" {
  type        = number
  description = "Initial storage size of the RDS instance"
  default     = 20
}

variable "rds_max_allocated_storage" {
  type        = number
  description = "Maximum storage size of the RDS instance"
  default     = 100
}

variable "rds_username" {
  type        = string
  description = "Master username of the RDS instance"
  default     = "postgres"
}

variable "rds_maintenance_window" {
  type        = string
  description = "Time when maintenance will be performed on the RDS instance during the week"
  default     = "Mon:03:00-Mon:04:00"
}

variable "rds_backup_window" {
  type        = string
  description = "Time when backup / snapshotting will be performed on the RDS instance every day"
  default     = "02:00-03:00"
}

variable "rds_backup_retention_period" {
  type        = number
  description = "How many days backups / snapshots of the RDS instance will be stored"
  default     = 7
}

variable "rds_skip_final_snapshot" {
  type        = bool
  description = "Decide whether you will skip final snapshot when RDS instance is deleted"
  default     = false
}

variable "rds_deletion_protection" {
  type        = bool
  description = "Decide whether RDS instance will be protected from accidental deletion"
  default     = true
}

variable "rds_copy_tags_to_snapshot" {
  type        = bool
  description = "Decide whether tags from the RDS instance will be copied to snapshot metadata"
  default     = true  
}

# ECS service variables
variable "ecs_service_frontend_desired_count" {
  type        = number
  description = "Desired number of ECS tasks for the frontend ECS service"
  default     = 1
}

variable "ecs_service_backend_desired_count" {
  type        = number
  description = "Desired number of ECS tasks for the backend ECS service"
  default     = 1
}

# ECS task variables
variable "ecs_task_frontend_memory" {
  type        = number
  description = "Memory setting in MB for frontend ECS task"
  default     = 512
}

variable "ecs_task_frontend_cpu" {
  type        = number
  description = "CPU setting in units (1024 = 1 vCPU) for frontend ECS task"
  default     = 512
}

variable "ecs_task_backend_memory" {
  type        = number
  description = "Memory setting in MB for backend ECS task"
  default     = 512
}

variable "ecs_task_backend_cpu" {
  type        = number
  description = "CPU setting in units (1024 = 1 vCPU) for backend ECS task"
  default     = 512
}

