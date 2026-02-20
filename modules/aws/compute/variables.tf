variable "name_prefix"        { type = string }
variable "environment"        { type = string }
variable "instance_type"      { type = string }
variable "instance_count"     { type = number }
variable "subnet_ids"         { type = list(string) }
variable "security_group_ids" { type = list(string) }
variable "common_tags"        { type = map(string) }
