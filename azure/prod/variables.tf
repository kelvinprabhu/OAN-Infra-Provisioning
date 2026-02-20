variable "subscription_id" {
  description = "Azure Subscription ID"
  type        = string
}
variable "azure_location" {
  description = "Azure region"
  type        = string
  default     = "East US"
}
variable "owner" {
  description = "Team or individual owning this environment"
  type        = string
}
variable "vnet_cidr" {
  description = "VNet address space CIDR"
  type        = string
}
variable "vm_size" {
  description = "Azure VM size"
  type        = string
}
variable "instance_count" {
  description = "Number of VMs"
  type        = number
  default     = 1
}
variable "db_sku" {
  description = "Azure Database SKU"
  type        = string
  default     = "B_Gen5_1"
}
variable "db_name" {
  description = "Database name"
  type        = string
}
