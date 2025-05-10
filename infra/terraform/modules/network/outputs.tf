output "vpc_self_link" {
  value       = google_compute_network.vpc.self_link
  description = "Self link da VPC"
}

output "subnet_self_link" {
  value       = google_compute_subnetwork.subnet.self_link
  description = "Self link da Subnet"
}

output "vpc_name" {
  value       = google_compute_network.vpc.name
  description = "Nome da VPC"
}
