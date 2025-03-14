terraform {
  backend "azurerm" {
    # resource_group_name  = "backend-rg"
    # storage_account_name = "progetsa"
    # container_name       = "project-container"
    # key                  = "project.tfstate"
    # subscription_id      = "a806834c-3019-42c1-867a-d95f6041277b"
 }
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "4.21.0"
    }
  }
}


provider "azurerm" {
  # Configuration options
features { }
subscription_id = var.subscription_id
}