output "resource_group" {
  description = "Resource group containing the cluster."
  value       = azurerm_resource_group.cosmos.name
}

output "cluster_name" {
  description = "Name of the AKS cluster."
  value       = azurerm_kubernetes_cluster.cosmos.name
}

output "get_credentials_command" {
  description = "Run this to point kubectl at the new cluster."
  value       = "az aks get-credentials --resource-group ${azurerm_resource_group.cosmos.name} --name ${azurerm_kubernetes_cluster.cosmos.name}"
}
