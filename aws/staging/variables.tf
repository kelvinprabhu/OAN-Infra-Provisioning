variable "aws_region" {
  description = "AWS region to deploy into"
  type        = string
  default     = "us-east-1"
}
variable "owner" {
  description = "Team or individual owning this environment"
  type        = string
}
variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}
variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}
variable "instance_count" {
  description = "Number of EC2 instances"
  type        = number
  default     = 1
}
variable "db_instance_class" {
  description = "RDS instance class"
  type        = string
  default     = "db.t3.micro"
}
variable "db_name" {
  description = "Database name"
  type        = string
}
