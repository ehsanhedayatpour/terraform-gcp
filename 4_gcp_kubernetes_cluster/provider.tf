terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "6.3.0"
    }
  }
}

provider "google" {
  project     = local.project_id 
  region      = local.region
  zone        = local.zone
}