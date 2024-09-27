
locals {
  region = "europe-west1"
  project_id = "a1ewb2zc3dv4kts"
  zone = "europe-west1-a"
}

data "google_container_registry_image" "default" {
  name   = "gke-${var.env}"
  region = var.region
  tag    = "${var.image_tag}"
}

resource "google_compute_network" "gke_network" {
  name                    = "${var.network_name}"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "subnetwork" {
  name          = var.subnet_name
  ip_cidr_range = var.gke_node_cidr
  region        = local.region 
  network       = google_compute_network.gke_network.id
  secondary_ip_range {
    range_name    = "pods-subnet"
    ip_cidr_range = var.pods_cidr
  }
  secondary_ip_range {
    range_name    = "services-subnet"
    ip_cidr_range = var.svc_cidr
  }
  depends_on = [
    google_compute_network.gke_network,
  ]
}

resource "google_container_cluster" "gke_cluster" {
  min_master_version = var.kubernetes_version
  name               = "gke-cluster-${var.env}"

  network            = google_compute_network.gke_network.name
  subnetwork         = google_compute_subnetwork.subnetwork.name

  ip_allocation_policy {
      cluster_secondary_range_name  = "pods-subnet"
      services_secondary_range_name = "services-subnet"
  }

  default_max_pods_per_node = 110
  remove_default_node_pool = true
  enable_legacy_abac = "false"
  deletion_protection = false

  addons_config {
    http_load_balancing {
      disabled = false
    }
  }

  private_cluster_config {
    master_ipv4_cidr_block = "172.16.0.0/28"
    enable_private_nodes   = true
  }

  lifecycle {
    ignore_changes = [node_pool]
  }

  node_pool {
    name = "default-pool"
  }
  logging_service    = "logging.googleapis.com/kubernetes"
  monitoring_service = "monitoring.googleapis.com/kubernetes"
 
  depends_on = [
    google_compute_subnetwork.subnetwork,
  ]
}

resource "google_container_node_pool" "gke_pool" {
  name       = "gke-pool-${var.env}"
  cluster    = "${google_container_cluster.gke_cluster.name}"
  node_count = "${var.node_count}"

  management {
    auto_repair  = true
    auto_upgrade = true
  }

  autoscaling {
    min_node_count = 1
    max_node_count = 3
  }

  node_config {
    oauth_scopes = [
      "https://www.googleapis.com/auth/compute",
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]

    disk_size_gb = 10
    machine_type = "${var.machine_type}"
  }
}