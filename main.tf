terraform {
  backend "azurerm" {
    resource_group_name  = "rg-terraform-state"
    storage_account_name = "stterraformstate9482"
    container_name       = "tfstate"
    key                  = "platform-foundation.tfstate"
  }
}

resource "azurerm_resource_group" "networking" {
  name      = var.networking_resource_group_name
  location  = var.location
}

resource "azurerm_virtual_network" "hub" {
  name                 = var.virtual_network_name
  location             = var.location
  resource_group_name  = var.networking_resource_group_name
}

resource "azurerm_subnet" "app" {
  name             = var.app_subnet_name
  virtual_network_name = var.virtual_network_name
  resource_group_name  = var.networking_resource_group_name
  address_prefixes = [var.app_subnet_address_prefix]
}

resource "azurerm_subnet" "data" {
  name             = var.data_subnet_name
  virtual_network_name = var.virtual_network_name
  resource_group_name  = var.networking_resource_group_name
  address_prefixes = [var.data_subnet_address_prefix]
}

resource "azurerm_subnet" "mgmt" {
  name             = var.management_subnet_name
  virtual_network_name = var.virtual_network_name
  resource_group_name  = var.networking_resource_group_name
  address_prefixes = [var.management_subnet_address_prefix]
}

resource "azurerm_network_security_group" "app" {
  name                = var.app_nsg_name
  location            = var.location
  resource_group_name = var.networking_resource_group_name
}

resource "azurerm_network_security_group" "data" {
  name                = var.data_nsg_name
  location            = var.location
  resource_group_name = var.networking_resource_group_name
}

resource "azurerm_network_security_group" "mgmt" {
  name                = var.mgmt_nsg_name
  location            = var.location
  resource_group_name = var.networking_resource_group_name
}

resource "azurerm_subnet_network_security_group_association" "app" {
  subnet_id                 = azurerm_subnet.app.id
  network_security_group_id = azurerm_network_security_group.app.id
}