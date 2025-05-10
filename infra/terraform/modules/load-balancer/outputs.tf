output "lb_ip" {
  value       = google_compute_address.default.address
  description = "IP externo do Load Balancer"
}
