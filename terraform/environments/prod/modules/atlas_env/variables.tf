variable "project_name" { type = string }
variable "org_id" { type = string }
variable "environment" { type = string }
variable "cluster_tier" {
  type    = string
  default = "M10"
}
variable "enable_backup" {
  type    = bool
  default = false
}
variable "db_password" {
  type      = string
  sensitive = true
}
variable "allowed_cidr" {
  type    = string
  default = "0.0.0.0/0"
}
variable "maintenance_day" {
  type    = number
  default = 1
} # Sunday
variable "maintenance_hour" {
  type    = number
  default = 2
} # 2 AM UTC

variable "region_configs" {
  description = "List of region configurations for the cluster"
  type = list(object({
    provider_name = string
    region_name   = string
    priority      = number
    node_count    = number
  }))
  default = [{
    provider_name = "AWS"
    region_name   = "US_EAST_1"
    priority      = 7
    node_count    = 3
  }]
}
