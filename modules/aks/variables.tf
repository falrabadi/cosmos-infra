variable "environment" {
  description = "Environment name (int, stage, prod). Drives resource naming."
  type        = string
}

variable "name_prefix" {
  description = "Prefix for resource names. Combined with environment, e.g. cosmos-int-rg."
  type        = string
  default     = "cosmos"
}

variable "location" {
  description = "Azure region. NOTE: this subscription is blocked from B-series in the big US regions (eastus/westus/etc.); northcentralus and westcentralus work."
  type        = string
  default     = "northcentralus"
}

variable "kubernetes_version" {
  description = "Kubernetes version. null = AKS default for the region."
  type        = string
  default     = null
}

variable "node_count" {
  description = "Number of nodes in the default node pool."
  type        = number
  default     = 1
}

variable "node_vm_size" {
  description = "Node VM size. Standard_B2als_v2 = 2 vCPU / 4 GiB (cheapest x86 that meets the AKS minimum)."
  type        = string
  default     = "Standard_B2als_v2"
}

variable "os_disk_size_gb" {
  description = "OS disk size per node, in GB."
  type        = number
  default     = 32
}

variable "tags" {
  description = "Extra tags merged onto every resource."
  type        = map(string)
  default     = {}
}
