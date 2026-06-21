variable "subscription_id" {
  description = "Azure subscription ID. Get it with: az account show --query id -o tsv"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group to create."
  type        = string
  default     = "cosmos-rg"
}

variable "location" {
  description = "Azure region. Note: this subscription can't use B-series in the big US regions (eastus/westus/etc.); northcentralus and westcentralus allow it."
  type        = string
  default     = "northcentralus"
}

variable "cluster_name" {
  description = "Name of the AKS cluster."
  type        = string
  default     = "cosmos-aks"
}

variable "kubernetes_version" {
  description = "Kubernetes version. Leave null to use the AKS default for the region."
  type        = string
  default     = null
}

variable "node_count" {
  description = "Number of nodes in the default node pool."
  type        = number
  default     = 1
}

variable "node_vm_size" {
  description = "Node VM size. Standard_B2als_v2 = 2 vCPU / 4 GiB (AKS minimum, cheapest x86/AMD)."
  type        = string
  default     = "Standard_B2als_v2"
}
