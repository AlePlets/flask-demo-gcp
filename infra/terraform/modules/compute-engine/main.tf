# IP externo fixo com tier PREMIUM
resource "google_compute_address" "static_ip" {
  name         = "${var.instance_name}-ip"
  project      = var.project_id
  region       = var.region
  network_tier = "PREMIUM"
}

resource "google_compute_instance" "vm" {
  name         = var.instance_name
  machine_type = var.machine_type
  zone         = var.zone
  project      = var.project_id

  tags = ["web", "iap-ssh"]

  boot_disk {
    initialize_params {
      image = var.image
      size  = 10
      type  = "pd-balanced"
    }
  }

  network_interface {
    subnetwork         = var.subnet
    subnetwork_project = var.project_id

    # access_config {
    #   # nat_ip       = google_compute_address.static_ip.address
    #   network_tier = "PREMIUM"
    # }
  }

  # metadata_startup_script = var.startup_script

  service_account {
    email  = var.service_account_email
    scopes = ["cloud-platform"]
  }

  labels = {
    app = "web"
  }

  scheduling {
    preemptible       = false
    automatic_restart = true
  }

  depends_on = [google_compute_address.static_ip]
}
