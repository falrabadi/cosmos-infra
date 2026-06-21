# A module declares the providers it NEEDS (version constraints), but never
# configures them — the `provider` block lives in the root/environment module.
# That's what lets one module be reused across int/stage/prod unchanged.
terraform {
  required_version = ">= 1.6"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
}
