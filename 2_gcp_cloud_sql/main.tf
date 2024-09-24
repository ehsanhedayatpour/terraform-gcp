locals {
  region = "europe-west1"
  zone = "europe-west1-b"
  project = "testproject"
}

# Create a GCP MySQL instance
resource "google_sql_database_instance" "mysql_instance" {
  name             = "my-mysql-instance"
  database_version = var.mysql_version
  region           = local.region

  settings {
    tier = "db-f1-micro"

    ip_configuration {
      ipv4_enabled = true
    }
  }
  deletion_protection = true
}

# Create a MySQL user
resource "google_sql_user" "mysql_user" {
  instance   = google_sql_database_instance.mysql_instance.name
  name       = var.mysql_username
  password   = var.mysql_password
}

# Create a MySQL database
resource "google_sql_database" "mysql_database" {
  name     = var.mysql_db_name
  instance = google_sql_database_instance.mysql_instance.name
}
