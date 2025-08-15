terraform {
  source = "../../../modules/firewall"
}

include {
  path = find_in_parent_folders("root.hcl")
}

locals {
  parent_config = read_terragrunt_config(find_in_parent_folders("root.hcl"))
}

# Wait for network to be created before firewall rules
dependencies {
  paths = ["../network"]
}

dependency "network" {
  config_path = "../network"
}

inputs = {
  project_id = local.parent_config.inputs.project_id
  network    = dependency.network.outputs.network_name

  rules = [
    {
      name           = "allow-ssh"
      description    = "Allow SSH from anywhere"
      direction      = "INGRESS"
      priority       = 1000
      ranges         = ["0.0.0.0/0"]
      allow          = [{ protocol = "tcp", ports = ["22"] }]
      enable_logging = true
    },
    {
      name           = "allow-internal"
      description    = "Allow internal traffic"
      direction      = "INGRESS"
      priority       = 1000
      ranges         = ["10.0.0.0/8"]
      allow          = [{ protocol = "all" }]
      enable_logging = true
    }
  ]
}
