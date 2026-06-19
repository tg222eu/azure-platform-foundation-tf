terraform {
  backend "azurerm" {
    resource_group_name  = "rg-terraform-state"
    storage_account_name = "stterraformstate9482"
    container_name       = "tfstate"
    key                  = "landing-zone.tfstate"
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "main"{
  name      = var.resource_group_name
  location  = var.location
}