resource "azurerm_resource_group" "cosmos" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_kubernetes_cluster" "cosmos" {
  name                = var.cluster_name
  location            = azurerm_resource_group.cosmos.location
  resource_group_name = azurerm_resource_group.cosmos.name
  dns_prefix          = var.cluster_name
  kubernetes_version  = var.kubernetes_version

  # Free control-plane tier — $0 for the managed control plane (no uptime SLA).
  sku_tier = "Free"

  default_node_pool {
    name            = "default"
    node_count      = var.node_count
    vm_size         = var.node_vm_size
    os_disk_size_gb = 32
  }

  # Managed identity for the cluster — no service principal secret to rotate.
  identity {
    type = "SystemAssigned"
  }

  tags = {
    project = "cosmos"
  }
}
