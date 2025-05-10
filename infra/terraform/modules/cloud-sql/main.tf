resource "google_project_service" "required" {
  for_each = toset([
    "sqladmin.googleapis.com",
    "servicenetworking.googleapis.com"
  ])
  service = each.key
  project = var.project_id
}

resource "google_compute_global_address" "psc" {
  name          = "sql-range-vpc"
  project       = var.project_id  
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  address       = var.peering_ip
  prefix_length = var.peering_prefix
  network       = var.vpc
  depends_on    = [google_project_service.required]
}

resource "google_service_networking_connection" "psc" {
  network                 = var.vpc
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.psc.name]
  depends_on = [
    google_compute_global_address.psc,
    google_project_service.required
  ]
}

resource "google_compute_network_peering_routes_config" "psc" {
  project               = var.project_id 
  network               = var.vpc
  peering               = google_service_networking_connection.psc.peering
  import_custom_routes  = true
  export_custom_routes  = true
  depends_on            = [google_service_networking_connection.psc]
}

resource "google_sql_database_instance" "postgres_instance" {
  name             = var.instance_name
  database_version = "POSTGRES_16"
  region           = var.region
  project          = var.project_id

  settings {
    tier              = var.tier
    edition          = "ENTERPRISE"
    availability_type = "ZONAL"

    ip_configuration {
      ipv4_enabled    = false
      private_network = var.peering_network
    }

    backup_configuration {
      enabled = true
    }
  }

  deletion_protection = false

  depends_on = [google_service_networking_connection.psc]
}

resource "google_sql_user" "default_user" {
  name     = "alessandra"
  instance = google_sql_database_instance.postgres_instance.name
  password = "123456"
  project  = var.project_id
}
