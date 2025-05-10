output "instance_connection_name" {
  value       = google_sql_database_instance.postgres_instance.connection_name
  description = "Nome de conexão para usar com Cloud SQL Proxy ou conectores"
}

output "instance_self_link" {
  value       = google_sql_database_instance.postgres_instance.self_link
  description = "Self link da instância"
}
