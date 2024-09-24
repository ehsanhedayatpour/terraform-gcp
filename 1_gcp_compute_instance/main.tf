locals {
  region = "europe-west1"
  zone = "europe-west1-b"
  project = "testproject"
}

resource "google_service_account" "ac" {
  account_id   = "my-serviceaccount"
  display_name = "ServiceAccount for VM Instance"
}

resource "google_compute_address" "static-ip" {
  depends_on = [ google_service_account.ac ]
  name = "static-ip"
  address_type = "EXTERNAL"
  network_tier = "PREMIUM"
}

resource "google_compute_instance" "my-instance" {
  depends_on = [ google_compute_address.static-ip ]
  name         = "my-compute-instance"
  machine_type = var.machine_type
  zone         = local.zone

  tags = ["env", "stage"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
      labels = {
        env = "stage"
      }
    }
  }

  metadata = {
    ssh-keys = "ehsan:${file("~/.ssh/id_rsa.pub")}"
  }

  scratch_disk {
    interface = var.disk_type
  }

  network_interface {
    network = "default"

    access_config {
      nat_ip = google_compute_address.static-ip.address
    }
  }

  metadata_startup_script = "echo hey > /tmp/message.txt"

  service_account {
    email  = google_service_account.ac.email
    scopes = ["cloud-platform"]
  }
}