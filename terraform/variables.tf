variable "hcloud_token" {
  description = "Hetzner Cloud API token. Provide via TF_VAR_hcloud_token env var or a gitignored *.tfvars file. NEVER commit this."
  type        = string
  sensitive   = true
}

variable "server_name" {
  description = "Name of the k3s server."
  type        = string
  default     = "cosmos-k3s"
}

variable "server_type" {
  description = "Hetzner server type. cx22 is the cheapest shared-vCPU option (2 vCPU / 4GB)."
  type        = string
  default     = "cx22"
}

variable "location" {
  description = "Hetzner datacenter location (nbg1 = Nuremberg, fsn1 = Falkenstein, hel1 = Helsinki)."
  type        = string
  default     = "nbg1"
}

variable "ssh_public_key" {
  description = "SSH public key used for server access."
  type        = string
}

variable "allowed_ssh_ip" {
  description = "CIDR allowed to SSH in, e.g. 1.2.3.4/32. Lock this to your own IP."
  type        = string
}
