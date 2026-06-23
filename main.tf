terraform {
  backend "azurerm" {
    resource_group_name  = "rg-terraform-state"
    storage_account_name = "stterraformstate9482"
    container_name       = "tfstate"
    key                  = "platform-foundation.tfstate"
  }
}

resource "azurerm_resource_group" "platform" {
  name      = var.platform_resource_group_name
  location  = var.location
  tags      = local.common_tags
}

# ==========================================
# Networking - VNet
# ==========================================

resource "azurerm_virtual_network" "hub" {
  name                 = var.virtual_network_name
  location             = var.location
  resource_group_name  = azurerm_resource_group.platform.name
  address_space        = ["10.0.0.0/16"]
  tags                 = local.common_tags
}

# ==========================================
# Networking - Subnets
# ==========================================

resource "azurerm_subnet" "app" {
  name                  = var.app_subnet_name
  virtual_network_name  = azurerm_virtual_network.hub.name
  resource_group_name   = azurerm_resource_group.platform.name
  address_prefixes      = [var.app_subnet_address_prefix]
}

resource "azurerm_subnet" "data" {
  name                  = var.data_subnet_name
  virtual_network_name  = azurerm_virtual_network.hub.name
  resource_group_name   = azurerm_resource_group.platform.name
  address_prefixes      = [var.data_subnet_address_prefix]
}

resource "azurerm_subnet" "mgmt" {
  name                  = var.management_subnet_name
  virtual_network_name  = azurerm_virtual_network.hub.name
  resource_group_name   = azurerm_resource_group.platform.name
  address_prefixes      = [var.management_subnet_address_prefix]
}

# ==========================================
# Security - Key Vault
# ==========================================

resource "azurerm_key_vault" "main" {
  name                        = var.key_vault_name
  location                    = var.location
  resource_group_name         = azurerm_resource_group.platform.name
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  sku_name                    = "standard"
  rbac_authorization_enabled  = true
  soft_delete_retention_days  = 0
  purge_protection_enabled    = false
  tags                        = local.common_tags
}

resource "azurerm_key_vault_secret" "test" {
  name          = "sample-secret"
  value         = var.secret_value # Have no purpose yet, just for testing
  key_vault_id  = azurerm_key_vault.main.id
  tags          = local.common_tags
}