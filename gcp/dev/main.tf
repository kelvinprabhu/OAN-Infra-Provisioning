###############################################################
# OAN-Infra-Provisioning | GCP | DEV
# Managed by Terraform — DO NOT EDIT MANUALLY
###############################################################

terraform {
  required_version = ">= 1.6.0"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
  backend "gcs" {
    bucket = "oan-tfstate-gcp-dev"
    prefix = "gcp/dev/terraform.tfstate"
  }
}

provider "google" {
  project = var.gcp_project_id
  region  = var.gcp_region
}

locals {
  env         = "dev"
  project     = "OAN"
  cloud       = "gcp"
  name_prefix = "oan-gcp-dev"
  common_labels = {
    project     = local.project
    environment = local.env
    managed_by  = "terraform"
    cloud       = local.cloud
    owner       = replace(var.owner, "@", "_at_")
  }
}

module "networking" {
  source        = "../../modules/gcp/networking"
  name_prefix   = local.name_prefix
  subnet_cidr   = var.subnet_cidr
  region        = var.gcp_region
  environment   = local.env
  common_labels = local.common_labels
}

module "compute" {
  source         = "../../modules/gcp/compute"
  name_prefix    = local.name_prefix
  environment    = local.env
  machine_type   = var.machine_type
  instance_count = var.instance_count
  subnetwork     = module.networking.subnetwork_self_link
  common_labels  = local.common_labels
}

module "storage" {
  source        = "../../modules/gcp/storage"
  name_prefix   = local.name_prefix
  environment   = local.env
  location      = var.gcp_region
  common_labels = local.common_labels
}

module "database" {
  source            = "../../modules/gcp/cloudsql"
  name_prefix       = local.name_prefix
  environment       = local.env
  database_tier     = var.database_tier
  db_name           = var.db_name
  network_id        = module.networking.network_id
  common_labels     = local.common_labels

  # Secrets from Google Secret Manager — never hardcoded
  db_user_secret     = "projects/${var.gcp_project_id}/secrets/oan-gcp-dev-db-user/versions/latest"
  db_password_secret = "projects/${var.gcp_project_id}/secrets/oan-gcp-dev-db-password/versions/latest"
}

module "iam" {
  source        = "../../modules/gcp/iam"
  name_prefix   = local.name_prefix
  environment   = local.env
  project_id    = var.gcp_project_id
  common_labels = local.common_labels
}
