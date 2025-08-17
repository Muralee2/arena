output "network_name" {
  value = google_compute_network.vpc.name
}

output "subnet_name" {
  value       = google_compute_subnetwork.subnet.name
  depends_on  = [time_sleep.wait_for_subnet]
}


output "project_id" {
  value = var.project_id
}

output "region" {
  value = var.region
}
