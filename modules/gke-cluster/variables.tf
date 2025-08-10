variable "cluster_name" {
  description = "Name of the GKE cluster"
  type        = string
}

variable "region" {
  description = "GCP region"
  type        = string
}

variable "network_name" {
  description = "Name of the VPC network"
  type        = string
}

variable "subnet_name" {
  description = "Name of the subnetwork"
  type        = string
}
variable "node_machine_type" {
  description = "The machine type for GKE nodes"
  type        = string
}

variable "node_count" {
  description = "The initial number of nodes in the node pool"
  type        = number
}
