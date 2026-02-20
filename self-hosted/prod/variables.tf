variable "vsphere_server" {
  description = "vSphere server hostname"
  type        = string
}
variable "vsphere_user" {
  description = "vSphere username"
  type        = string
  sensitive   = true
}
variable "vsphere_password" {
  description = "vSphere password"
  type        = string
  sensitive   = true
}
variable "vsphere_allow_unverified_ssl" {
  description = "Allow unverified SSL for vSphere"
  type        = bool
  default     = false
}
variable "vsphere_datacenter" {
  description = "vSphere datacenter name"
  type        = string
}
variable "vsphere_cluster" {
  description = "vSphere cluster name"
  type        = string
}
variable "vsphere_datastore" {
  description = "vSphere datastore name"
  type        = string
}
variable "vm_template" {
  description = "VM template to clone"
  type        = string
}
variable "num_cpus" {
  description = "Number of vCPUs per VM"
  type        = number
  default     = 2
}
variable "memory_mb" {
  description = "Memory per VM in MB"
  type        = number
  default     = 4096
}
variable "instance_count" {
  description = "Number of VM instances"
  type        = number
  default     = 1
}
variable "vlan_id" {
  description = "VLAN ID for networking"
  type        = number
}
variable "subnet_cidr" {
  description = "Subnet CIDR"
  type        = string
}
variable "nfs_server" {
  description = "NFS server address"
  type        = string
}
variable "nfs_path" {
  description = "NFS export path"
  type        = string
}
variable "vault_address" {
  description = "HashiCorp Vault address"
  type        = string
}
variable "vault_token" {
  description = "Vault token (use env var VAULT_TOKEN)"
  type        = string
  sensitive   = true
}
variable "tf_backend_address" {
  description = "Terraform HTTP backend URL"
  type        = string
}
variable "owner" {
  description = "Team or individual owning this environment"
  type        = string
}
