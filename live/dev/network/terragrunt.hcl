terraform {
  source = "../../../modules/network"
}

include {
  path = find_in_parent_folders("root.hcl")
}

locals {
  parent_config = read_terragrunt_config(find_in_parent_folders("root.hcl"))
}

inputs = {
  project_id              = local.parent_config.inputs.project_id
  network_name            = local.parent_config.inputs.network_name
  auto_create_subnetworks = false

  subnets = [
    {
      subnet_name           = local.parent_config.inputs.subnet_name
      subnet_ip             = local.parent_config.inputs.subnet_cidr
      subnet_region         = local.parent_config.inputs.region
      subnet_private_access = true
      subnet_flow_logs      = true
    }
  ]
}

