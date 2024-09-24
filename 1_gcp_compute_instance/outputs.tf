output "instance_name" {
  description = "The name of the compute instance"
  value       = google_compute_instance.my-instance.name
}

output "instance_zone" {
  description = "The zone in which the instance is created"
  value       = google_compute_instance.my-instance.zone
}

output "instance_external_ip" {
  description = "The external IP of the instance"
  value       = google_compute_address.static-ip.address
}

output "instance_internal_ip" {
  description = "The internal IP of the instance"
  value       = google_compute_instance.my-instance.network_interface[0].network_ip
}

output "instance_service_account_email" {
  description = "The email of the service account attached to the instance"
  value       = google_compute_instance.my-instance.service_account[0].email
}

output "instance_machine_type" {
  description = "The machine type of the compute instance"
  value       = google_compute_instance.my-instance.machine_type
}
