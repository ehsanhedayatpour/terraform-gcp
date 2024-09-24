output "instance_connection_name" {
  description = "The connection name of the Cloud SQL instance"
  value       = google_sql_database_instance.mysql_instance.connection_name
}

output "public_ip_address" {
  description = "The public IP address  of the MySQL instance"
  value       = google_sql_database_instance.mysql_instance.public_ip_address
}

output "mysql_connection_url" {
  description = "The MySQL connection URL"
  value       = "mysql://myuser:${google_sql_user.mysql_user.password}@${google_sql_database_instance.mysql_instance.public_ip_address}/${google_sql_database.mysql_database.name}"
  sensitive   = true
}