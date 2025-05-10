resource "google_compute_network" "vpc" {
  name                    = var.vpc_name
  auto_create_subnetworks = false
  project                 = var.project_id
}

resource "google_compute_subnetwork" "subnet" {
  name          = var.subnet_name
  ip_cidr_range = var.subnet_cidr
  region        = var.region
  network       = google_compute_network.vpc.id
  project       = var.project_id
  private_ip_google_access = true
}

# Firewall: permite IAP (TCP 22 para SSH via proxy)
resource "google_compute_firewall" "iap_ssh" {
  name    = "${var.vpc_name}-allow-iap-ssh"
  network = google_compute_network.vpc.name
  project = var.project_id

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["35.235.240.0/20"]
  target_tags   = ["iap-ssh"]
  direction     = "INGRESS"
}

# Firewall: permite HTTP e HTTPS
resource "google_compute_firewall" "web" {
  name    = "${var.vpc_name}-allow-http-https"
  network = google_compute_network.vpc.name
  project = var.project_id

  allow {
    protocol = "tcp"
    ports    = ["80", "443"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["web"]
  direction     = "INGRESS"
}

# Firewall: permite tráfego interno
resource "google_compute_firewall" "internal" {
  name    = "${var.vpc_name}-allow-internal"
  network = google_compute_network.vpc.name
  project = var.project_id

  allow {
    protocol = "all"
  }

  source_ranges = [var.subnet_cidr]
  direction     = "INGRESS"
}

#Firewall: configura o health check
resource "google_compute_firewall" "allow-health-checks" {
  name    = "${var.vpc_name}-allow-health-checks"
  network = google_compute_network.vpc.name
  project = var.project_id

  description = "Permite tráfego dos health checks do Google"

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  source_ranges = [
    "35.191.0.0/16",
    "130.211.0.0/22"
  ]

  target_tags = ["web"]
  direction   = "INGRESS"
}
