output "vpc_id" {
  description = "VPC ID"
  value       = module.networking.vpc_id
}
output "private_subnet_ids" {
  description = "Private subnet IDs"
  value       = module.networking.private_subnet_ids
}
output "compute_instance_ids" {
  description = "EC2 instance IDs"
  value       = module.compute.instance_ids
}
output "s3_bucket_name" {
  description = "Primary S3 bucket"
  value       = module.storage.bucket_name
}
output "rds_endpoint" {
  description = "RDS endpoint"
  value       = module.database.endpoint
  sensitive   = true
}
