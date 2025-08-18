output "network_name" {
  value = google_compute_network.vpc.name
}

output "project_id" {
  value = var.project_id
}

output "subnet_name" {
  value = google_compute_subnetwork.subnet.name
}

output "subnet_region" {
  value = google_compute_subnetwork.subnet.region
}

output "region" {
  value = var.region
  description = "Region where the subnet is created"
}
