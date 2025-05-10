resource "google_compute_instance_group" "app_group" {
  name      = "${var.name}-instance-group"
  zone      = var.zone
  project   = var.project_id
  instances = [var.instance_self_link]

  named_port {
    name = "http"
    port = 80
  }
}

resource "google_compute_health_check" "http" {
  name               = "${var.name}-http-health-check"
  project            = var.project_id
  check_interval_sec = 5
  timeout_sec        = 5
  healthy_threshold  = 2
  unhealthy_threshold = 3

  http_health_check {
    port         = 80
    request_path = "/"
  }
}

resource "google_compute_backend_service" "default" {
  name                            = "${var.name}-backend-service"
  project                         = var.project_id
  protocol                        = "HTTP"
  port_name                       = "http"
  health_checks                   = [google_compute_health_check.http.self_link]
  timeout_sec                     = 10
  enable_cdn                      = false
  connection_draining_timeout_sec = 0
  load_balancing_scheme           = "EXTERNAL"

  backend {
    group = google_compute_instance_group.app_group.self_link
  }
}

resource "google_compute_url_map" "default" {
  name            = "${var.name}-url-map"
  project         = var.project_id
  default_service = google_compute_backend_service.default.self_link
}

resource "google_compute_target_http_proxy" "default" {
  name     = "${var.name}-http-proxy"
  project  = var.project_id
  url_map  = google_compute_url_map.default.self_link
}

resource "google_compute_address" "default" {
  name         = "${var.name}-ip"
  project      = var.project_id
  region       = var.region
  address_type = "EXTERNAL"
  network_tier = "STANDARD"
}

resource "google_compute_forwarding_rule" "default" {
  name                  = "${var.name}-forwarding-rule"
  project               = var.project_id
  region                = var.region
  ip_address            = google_compute_address.default.address
  port_range            = "80"
  target                = google_compute_target_http_proxy.default.self_link
  load_balancing_scheme = "EXTERNAL"
  network_tier          = "STANDARD"
}
