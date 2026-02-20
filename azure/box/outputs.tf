output "resource_group_name" {
  value = azurerm_resource_group.main.name
}
output "vnet_id" {
  value = module.networking.vnet_id
}
output "vm_ids" {
  value = module.compute.vm_ids
}
output "storage_account_name" {
  value = module.storage.storage_account_name
}
output "db_fqdn" {
  value     = module.database.fqdn
  sensitive = true
}
