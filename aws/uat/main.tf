###############################################################
# OAN-Infra-Provisioning | AWS | uat
# Managed by Terraform — DO NOT EDIT MANUALLY
###############################################################

terraform {
  required_version = ">= 1.6.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  backend "s3" {
    bucket         = "oan-tfstate-aws-uat"
    key            = "aws/uat/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "oan-tfstate-lock-uat"
    encrypt        = true
  }
}

provider "aws" {
  region = var.aws_region
  default_tags {
    tags = local.common_tags
  }
}

locals {
  env         = "uat"
  project     = "OAN"
  cloud       = "aws"
  name_prefix = "oan-aws-uat"
  common_tags = {
    project     = local.project
    environment = local.env
    managed_by  = "terraform"
    cloud       = local.cloud
    owner       = var.owner
  }
}

module "networking" {
  source      = "../../modules/aws/networking"
  name_prefix = local.name_prefix
  vpc_cidr    = var.vpc_cidr
  environment = local.env
  common_tags = local.common_tags
}

module "compute" {
  source             = "../../modules/aws/compute"
  name_prefix        = local.name_prefix
  environment        = local.env
  instance_type      = var.instance_type
  instance_count     = var.instance_count
  subnet_ids         = module.networking.private_subnet_ids
  security_group_ids = [module.networking.app_sg_id]
  common_tags        = local.common_tags
}

module "storage" {
  source      = "../../modules/aws/storage"
  name_prefix = local.name_prefix
  environment = local.env
  common_tags = local.common_tags
}

module "database" {
  source                 = "../../modules/aws/rds"
  name_prefix            = local.name_prefix
  environment            = local.env
  db_instance_class      = var.db_instance_class
  db_name                = var.db_name
  subnet_ids             = module.networking.private_subnet_ids
  security_group_ids     = [module.networking.db_sg_id]
  db_username_secret_arn = data.aws_secretsmanager_secret.db_username.arn
  db_password_secret_arn = data.aws_secretsmanager_secret.db_password.arn
  common_tags            = local.common_tags
}

module "iam" {
  source      = "../../modules/aws/iam"
  name_prefix = local.name_prefix
  environment = local.env
  common_tags = local.common_tags
}

# ── Secrets references (AWS Secrets Manager) ─────────────────
data "aws_secretsmanager_secret" "db_username" {
  name = "oan/aws/uat/db/username"
}
data "aws_secretsmanager_secret" "db_password" {
  name = "oan/aws/uat/db/password"
}
