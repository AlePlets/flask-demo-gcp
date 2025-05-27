resource "google_compute_router" "router" {
  name    = var.router_name
  region  = var.region
  network = var.network_self_link
  project = var.project_id
}

resource "google_compute_router_nat" "nat" {
  name                               = var.nat_name
  router                             = google_compute_router.router.name
  region                             = var.region
  project                            = var.project_id
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"

  log_config {
    enable = var.enable_logging
    filter = "ALL"
  }
}
