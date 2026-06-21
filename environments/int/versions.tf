terraform {
  required_version = ">= 1.6"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }

  # Remote state — each environment gets its OWN state file (own `key`),
  # so an int apply can never read or corrupt stage/prod state.
  # Uncomment once the Azure Storage backend exists:
  #
  # backend "azurerm" {
  #   resource_group_name  = "cosmos-tfstate-rg"
  #   storage_account_name = "cosmostfstate"
  #   container_name       = "tfstate"
  #   key                  = "int.terraform.tfstate"
  # }
}

provider "azurerm" {
  subscription_id = var.subscription_id

  # Don't auto-register every Azure resource provider (slow on a fresh
  # subscription). We register just the ones AKS needs, manually, once.
  resource_provider_registrations = "none"

  features {}
}
