terraform {
  required_version = ">= 1.6"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }

  # Remote state backend.
  # State holds secrets and the full map of your infra — it must NOT live in git.
  # Point this at an Azure Storage account once it exists:
  #
  # backend "azurerm" {
  #   resource_group_name  = "cosmos-tfstate-rg"
  #   storage_account_name = "cosmostfstate"
  #   container_name       = "tfstate"
  #   key                  = "infra.terraform.tfstate"
  # }
}

provider "azurerm" {
  subscription_id = var.subscription_id

  # Don't auto-register every Azure resource provider (slow on a fresh
  # subscription). We register just the ones AKS needs, manually, once.
  resource_provider_registrations = "none"

  features {}
}
