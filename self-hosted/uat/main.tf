###############################################################
# OAN-Infra-Provisioning | Self-Hosted (On-Prem) | UAT
# Managed by Terraform — DO NOT EDIT MANUALLY
###############################################################

terraform {
  required_version = ">= 1.6.0"
  required_providers {
    vsphere = {
      source  = "hashicorp/vsphere"
      version = "~> 2.5"
    }
    vault = {
      source  = "hashicorp/vault"
      version = "~> 3.0"
    }
  }
  # Self-hosted: use Terraform Cloud or HTTP backend pointing to internal storage
  backend "http" {
    address        = "${var.tf_backend_address}"
    lock_address   = "${var.tf_backend_address}/lock"
    unlock_address = "${var.tf_backend_address}/lock"
    lock_method    = "POST"
    unlock_method  = "DELETE"
  }
}

provider "vsphere" {
  user                 = var.vsphere_user
  password             = var.vsphere_password
  vsphere_server       = var.vsphere_server
  allow_unverified_ssl = var.vsphere_allow_unverified_ssl
}

provider "vault" {
  address = var.vault_address
  token   = var.vault_token   # Injected via CI/CD env var VAULT_TOKEN
}

locals {
  env         = "uat"
  project     = "OAN"
  cloud       = "self-hosted"
  name_prefix = "oan-sh-uat"
  common_tags = {
    project     = local.project
    environment = local.env
    managed_by  = "terraform"
    cloud       = local.cloud
    owner       = var.owner
  }
}

module "networking" {
  source      = "../../modules/self-hosted/networking"
  name_prefix = local.name_prefix
  environment = local.env
  vlan_id     = var.vlan_id
  subnet_cidr = var.subnet_cidr
}

module "compute" {
  source             = "../../modules/self-hosted/compute"
  name_prefix        = local.name_prefix
  environment        = local.env
  datacenter         = var.vsphere_datacenter
  cluster            = var.vsphere_cluster
  datastore          = var.vsphere_datastore
  template           = var.vm_template
  num_cpus           = var.num_cpus
  memory_mb          = var.memory_mb
  instance_count     = var.instance_count
  network_id         = module.networking.network_id
}

module "storage" {
  source      = "../../modules/self-hosted/storage"
  name_prefix = local.name_prefix
  environment = local.env
  nfs_server  = var.nfs_server
  nfs_path    = var.nfs_path
}

# ── Secrets from HashiCorp Vault ─────────────────────────────
data "vault_generic_secret" "db_credentials" {
  path = "secret/oan/self-hosted/uat/db"
}
