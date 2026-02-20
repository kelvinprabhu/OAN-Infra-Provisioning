###############################################################
# Module: aws/rds
###############################################################

data "aws_secretsmanager_secret_version" "db_username" {
  secret_id = var.db_username_secret_arn
}

data "aws_secretsmanager_secret_version" "db_password" {
  secret_id = var.db_password_secret_arn
}

resource "aws_db_subnet_group" "main" {
  name       = "${var.name_prefix}-db-subnet-group"
  subnet_ids = var.subnet_ids
  tags       = var.common_tags
}

resource "aws_db_instance" "main" {
  identifier              = "${var.name_prefix}-rds"
  engine                  = "postgres"
  engine_version          = "15"
  instance_class          = var.db_instance_class
  db_name                 = var.db_name
  username                = data.aws_secretsmanager_secret_version.db_username.secret_string
  password                = data.aws_secretsmanager_secret_version.db_password.secret_string
  db_subnet_group_name    = aws_db_subnet_group.main.name
  vpc_security_group_ids  = var.security_group_ids
  storage_encrypted       = true
  backup_retention_period = var.environment == "prod" ? 30 : 7
  deletion_protection     = var.environment == "prod"
  skip_final_snapshot     = var.environment != "prod"
  tags                    = merge(var.common_tags, { Name = "${var.name_prefix}-rds" })
}
