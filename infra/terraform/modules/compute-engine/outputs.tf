output "instance_name" {
  value       = google_compute_instance.vm.name
  description = "Nome da instância"
}

output "instance_self_link" {
  value       = google_compute_instance.vm.self_link
  description = "Self link da instância"
}

output "instance_network_interface" {
  value       = google_compute_instance.vm.network_interface
  description = "Interface de rede da VM"
}
