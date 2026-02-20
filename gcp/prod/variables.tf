variable "gcp_project_id" {
  description = "GCP Project ID"
  type        = string
}
variable "gcp_region" {
  description = "GCP region"
  type        = string
  default     = "us-central1"
}
variable "owner" {
  description = "Team or individual owning this environment"
  type        = string
}
variable "subnet_cidr" {
  description = "Subnet CIDR range"
  type        = string
}
variable "machine_type" {
  description = "GCE machine type"
  type        = string
}
variable "instance_count" {
  description = "Number of GCE instances"
  type        = number
  default     = 1
}
variable "database_tier" {
  description = "Cloud SQL tier"
  type        = string
  default     = "db-f1-micro"
}
variable "db_name" {
  description = "Database name"
  type        = string
}
