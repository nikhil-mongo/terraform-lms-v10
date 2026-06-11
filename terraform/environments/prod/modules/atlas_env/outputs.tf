# V9 Module — modules/atlas_env/outputs.tf

output "project_id" {
  description = "Atlas project ID"
  value       = mongodbatlas_project.env.id
}

output "cluster_name" {
  description = "Atlas cluster name"
  value       = mongodbatlas_advanced_cluster.env.name
}

output "connection_string" {
  description = "MongoDB SRV connection string"
  value       = mongodbatlas_advanced_cluster.env.connection_strings.standard_srv
  sensitive   = true
}

output "atlas_ui_url" {
  description = "Direct link to project in Atlas UI"
  value       = "https://cloud.mongodb.com/v2/${mongodbatlas_project.env.id}"
}
