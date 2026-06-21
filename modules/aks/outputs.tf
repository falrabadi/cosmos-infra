output "resource_group" {
  description = "Resource group containing the cluster."
  value       = azurerm_resource_group.this.name
}

output "cluster_name" {
  description = "Name of the AKS cluster."
  value       = azurerm_kubernetes_cluster.this.name
}

output "cluster_id" {
  description = "Azure resource ID of the cluster (handy for the app tier to reference)."
  value       = azurerm_kubernetes_cluster.this.id
}

output "get_credentials_command" {
  description = "Run this to point kubectl at the cluster."
  value       = "az aks get-credentials --resource-group ${azurerm_resource_group.this.name} --name ${azurerm_kubernetes_cluster.this.name}"
}
