output "network_id" {
  value = module.networking.network_id
}
output "subnetwork_self_link" {
  value = module.networking.subnetwork_self_link
}
output "instance_names" {
  value = module.compute.instance_names
}
output "bucket_name" {
  value = module.storage.bucket_name
}
output "cloudsql_connection_name" {
  value     = module.database.connection_name
  sensitive = true
}
