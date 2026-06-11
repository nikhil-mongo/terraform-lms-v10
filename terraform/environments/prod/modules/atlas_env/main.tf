# V9 Module — modules/atlas_env/main.tf
# Used by all 3 environments: dev, staging, prod

resource "mongodbatlas_project" "env" {
  name   = var.project_name
  org_id = var.org_id
}

resource "mongodbatlas_advanced_cluster" "env" {
  project_id     = mongodbatlas_project.env.id
  name           = "${var.environment}-cluster"
  cluster_type   = "REPLICASET"
  backup_enabled = var.enable_backup

  replication_specs = [
    {
      region_configs = [
        for rc in var.region_configs : {
          provider_name = rc.provider_name
          region_name   = rc.region_name
          priority      = rc.priority
          electable_specs = {
            instance_size = var.cluster_tier
            node_count    = rc.node_count
          }
        }
      ]
    }
  ]

  tags = {
    owner       = "dawa.lama"
    region      = "APAC-DEL"
    weekend_off = "saturday.sunday"
    Environment = var.environment
    deployed    = "nikhil.singh"
  }

  lifecycle {
    prevent_destroy = false
  }
}

resource "mongodbatlas_maintenance_window" "env" {
  project_id  = mongodbatlas_project.env.id
  day_of_week = var.maintenance_day
  hour_of_day = var.maintenance_hour
}

resource "mongodbatlas_database_user" "app" {
  username           = "${var.environment}-app-user"
  password           = var.db_password
  project_id         = mongodbatlas_project.env.id
  auth_database_name = "admin"
  roles {
    role_name     = "readWrite"
    database_name = "appdb"
  }
}

resource "mongodbatlas_project_ip_access_list" "access" {
  project_id = mongodbatlas_project.env.id
  cidr_block = var.allowed_cidr
  comment    = "${var.environment} — managed by Terraform"
}
locals {
  username = "nikhil.singh@mongodb.com"
  roles    = ["GROUP_OWNER"]
}
resource "mongodbatlas_cloud_user_project_assignment" "demo" {
  project_id = mongodbatlas_project.env.id
  username   = local.username
  roles      = local.roles
}
