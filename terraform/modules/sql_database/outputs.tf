output "sql_instance_name" {
  description = "The name of the created SQL database instance"
  value       = google_sql_database_instance.db.name
}

output "sql_instance_connection_name" {
  description = "The connection name of the created SQL database instance"
  value       = google_sql_database_instance.db.connection_name
}