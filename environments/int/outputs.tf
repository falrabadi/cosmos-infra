output "resource_group" {
  description = "Resource group containing the int cluster."
  value       = module.aks.resource_group
}

output "cluster_name" {
  description = "Name of the int AKS cluster."
  value       = module.aks.cluster_name
}

output "get_credentials_command" {
  description = "Run this to point kubectl at the int cluster."
  value       = module.aks.get_credentials_command
}
