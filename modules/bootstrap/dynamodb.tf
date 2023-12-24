resource "aws_dynamodb_table" "terraform" {
  name           = format("%s-%s-terraform-lock", var.project_name, var.environment)
  hash_key       = "LockID"
  read_capacity  = 1
  write_capacity = 1
 
  attribute {
    name = "LockID"
    type = "S"
  }
 
  tags = {
    Environment = var.environment
  }
}
