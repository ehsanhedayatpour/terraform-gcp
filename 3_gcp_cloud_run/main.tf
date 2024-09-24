locals {
  region = "europe-west1"
  project = "testproject"
  zone = "europe-west1-b"
}

# Create a Cloud Run service
resource "google_cloud_run_service" "nginx_service" {
  name     = "nginx-service"
  location = local.region

  template {
    spec {
      containers {
        image = "nginx:latest"
        ports {
          container_port = 80
        }
      }
    }
  }

  traffic {
    percent = 100
    latest_revision = true
  }
}

# Grant the Cloud Run Invoker role to the allUsers (public access)
resource "google_cloud_run_service_iam_member" "public_access" {
  service     = google_cloud_run_service.nginx_service.name
  location    = google_cloud_run_service.nginx_service.location
  role        = "roles/run.invoker"
  member      = "allUsers"
}
