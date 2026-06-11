# V10 Demo — main.tf (production config with all best practices)
# ==============================================================

module "prod" {
  source           = "./modules/atlas_env"
  org_id           = jsondecode(data.aws_secretsmanager_secret_version.my_secret_version.secret_string)["org_id"]
  project_name     = "myapp-prod"
  environment      = "prod"
  cluster_tier     = "M50"
  enable_backup    = true
  db_password      = jsondecode(data.aws_secretsmanager_secret_version.my_secret_version.secret_string)["prod_db_password"]
  allowed_cidr     = var.prod_cidr
  maintenance_day  = 1
  maintenance_hour = 2

  region_configs = [
    { provider_name = "AWS"
      region_name   = "US_EAST_1"
      priority      = 7
      node_count    = 3
    },
    { provider_name = "AWS"
      region_name   = "EU_WEST_1"
      priority      = 6
      node_count    = 2
    }
  ]
}
