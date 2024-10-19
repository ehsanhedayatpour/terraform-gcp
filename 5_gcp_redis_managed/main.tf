
locals {
  region  = "europe-west4"
  project = "testproject"
  location    = "europe-west4-a"
  alternative_location = "europe-west4-b"
}

resource "google_redis_instance" "redis_instance" {
  name           = "my-redis-instance"
  tier           = "STANDARD_HA"
  memory_size_gb = 3

  region                  = local.region
  location_id             = local.location
  alternative_location_id = local.alternative_location

  authorized_network = "default"

  redis_version     = "REDIS_6_0"
  display_name      = "My Redis Instance"
  reserved_ip_range = "192.168.0.0/29"

  labels = {
    env = "staging"
  }

  maintenance_policy {
    weekly_maintenance_window {
      day = "TUESDAY"
      start_time {
        hours   = 0
        minutes = 30
        seconds = 0
        nanos   = 0
      }
    }
  }

  lifecycle {
    prevent_destroy = true
  }
}