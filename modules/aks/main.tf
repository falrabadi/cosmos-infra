locals {
  resource_group_name = "${var.name_prefix}-${var.environment}-rg"
  cluster_name        = "${var.name_prefix}-${var.environment}-aks"

  tags = merge(
    {
      project     = var.name_prefix
      environment = var.environment
    },
    var.tags,
  )
}

resource "azurerm_resource_group" "this" {
  name     = local.resource_group_name
  location = var.location
}

resource "azurerm_kubernetes_cluster" "this" {
  name                = local.cluster_name
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  dns_prefix          = local.cluster_name
  kubernetes_version  = var.kubernetes_version

  # Free control-plane tier — $0 for the managed control plane (no uptime SLA).
  sku_tier = "Free"

  default_node_pool {
    name            = "default"
    node_count      = var.node_count
    vm_size         = var.node_vm_size
    os_disk_size_gb = var.os_disk_size_gb
  }

  # Managed identity — no service principal secret to rotate.
  identity {
    type = "SystemAssigned"
  }

  tags = local.tags
}
