output "network_name" {
  value = google_compute_network.vpc.name
}

output "subnet_name" {
  value      = google_compute_subnetwork.subnet.name
}

output "project_id" {
  value = var.project_id
}

output "region" {
  value = var.region
}
