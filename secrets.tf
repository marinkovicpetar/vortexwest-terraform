resource "aws_secretsmanager_secret" "rds_credentials" {
  name = format("%s-%s-rds-credentials", var.project_name, var.environment)
}

resource "aws_secretsmanager_secret_version" "rds_credentials" {
  secret_id     = aws_secretsmanager_secret.rds_credentials.id
  secret_string = <<EOF
{
  "username": "${module.rds.db_instance_username}",
  "password": "${random_password.rds.result}",
  "address": "${module.rds.db_instance_address}",
  "endpoint": "${module.rds.db_instance_endpoint}",
  "port": ${module.rds.db_instance_port}
}
EOF

  depends_on = [
    module.rds
  ]
}