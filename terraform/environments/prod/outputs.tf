# V10 Demo — outputs.tf

output "prod_project_id" {
  description = "Production Atlas project ID"
  value       = module.prod.project_id
}

output "prod_cluster_name" {
  description = "Production cluster name"
  value       = module.prod.cluster_name
}

output "prod_atlas_ui_url" {
  description = "Direct link to production project in Atlas UI"
  value       = module.prod.atlas_ui_url
}

output "prod_connection_string" {
  description = "Production MongoDB SRV connection string"
  value       = module.prod.connection_string
  sensitive   = true
  # Retrieve with: terraform output -raw prod_connection_string
}
