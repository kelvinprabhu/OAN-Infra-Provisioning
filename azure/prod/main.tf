###############################################################
# OAN-Infra-Provisioning | Azure | PROD
# Managed by Terraform — DO NOT EDIT MANUALLY
###############################################################

terraform {
  required_version = ">= 1.6.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
  backend "azurerm" {
    resource_group_name  = "oan-tfstate-rg"
    storage_account_name = "oantfstateazureprod"
    container_name       = "tfstate"
    key                  = "azure/prod/terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
}

locals {
  env         = "prod"
  project     = "OAN"
  cloud       = "azure"
  name_prefix = "oan-azure-prod"
  common_tags = {
    project     = local.project
    environment = local.env
    managed_by  = "terraform"
    cloud       = local.cloud
    owner       = var.owner
  }
}

resource "azurerm_resource_group" "main" {
  name     = "${local.name_prefix}-rg"
  location = var.azure_location
  tags     = local.common_tags
}

module "networking" {
  source              = "../../modules/azure/networking"
  name_prefix         = local.name_prefix
  resource_group_name = azurerm_resource_group.main.name
  location            = var.azure_location
  vnet_address_space  = [var.vnet_cidr]
  environment         = local.env
  common_tags         = local.common_tags
}

module "compute" {
  source              = "../../modules/azure/compute"
  name_prefix         = local.name_prefix
  resource_group_name = azurerm_resource_group.main.name
  location            = var.azure_location
  vm_size             = var.vm_size
  instance_count      = var.instance_count
  subnet_id           = module.networking.private_subnet_id
  common_tags         = local.common_tags
}

module "storage" {
  source              = "../../modules/azure/storage"
  name_prefix         = local.name_prefix
  resource_group_name = azurerm_resource_group.main.name
  location            = var.azure_location
  environment         = local.env
  common_tags         = local.common_tags
}

module "database" {
  source              = "../../modules/azure/database"
  name_prefix         = local.name_prefix
  resource_group_name = azurerm_resource_group.main.name
  location            = var.azure_location
  sku_name            = var.db_sku
  db_name             = var.db_name
  subnet_id           = module.networking.private_subnet_id
  common_tags         = local.common_tags

  # Secrets from Azure Key Vault — never hardcoded
  key_vault_id        = data.azurerm_key_vault.main.id
  db_admin_login_secret    = "oan-azure-prod-db-admin-login"
  db_admin_password_secret = "oan-azure-prod-db-admin-password"
}

module "iam" {
  source              = "../../modules/azure/iam"
  name_prefix         = local.name_prefix
  resource_group_name = azurerm_resource_group.main.name
  environment         = local.env
  common_tags         = local.common_tags
}

# ── Secrets (Azure Key Vault reference) ───────────────────────
data "azurerm_key_vault" "main" {
  name                = "oan-prod-kv"
  resource_group_name = "oan-secrets-rg"
}
