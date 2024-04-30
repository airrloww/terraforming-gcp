# create a SQL database instance
resource "google_sql_database_instance" "db" {
  name                = "database-${var.project_id}"
  database_version    = "POSTGRES_13" # version
  region              = "europe-north1"
  root_password       = var.root_password
  deletion_protection = false

  settings {
    tier              = var.tier
    edition           = var.edition
    availability_type = var.availability_type
  }
}