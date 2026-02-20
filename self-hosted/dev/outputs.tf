output "vm_names" {
  value = module.compute.vm_names
}
output "vm_ip_addresses" {
  value     = module.compute.ip_addresses
  sensitive = true
}
