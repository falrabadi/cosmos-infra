# Integration environment.
# This file is deliberately thin: it picks the module and the env-specific
# sizing — nothing else. To add a new lower environment, copy this directory,
# change `environment`, and adjust the knobs below.
module "aks" {
  source = "../../modules/aks"

  environment = "int"

  # Cheapest viable sizing for a lower environment.
  location     = "northcentralus"
  node_count   = 1
  node_vm_size = "Standard_B2als_v2"
}
