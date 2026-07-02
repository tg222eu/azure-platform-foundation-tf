# =============================================================================
# MAIN - Platform Foundation
# =============================================================================

terraform {
  backend "azurerm" {
    resource_group_name  = "rg-terraform-state"
    storage_account_name = "stterraformstate9482"
    container_name       = "tfstate"
    key                  = "platform-foundation.tfstate"
  }
}

data "azurerm_client_config" "current_user" {}

resource "azurerm_resource_group" "platform" {
  name      = var.platform_resource_group_name
  location  = var.location
  tags      = local.common_tags
}

# =============================================================================
# Networking - VNet
# =============================================================================

resource "azurerm_virtual_network" "hub" {
  name                 = var.virtual_network_name
  location             = var.location
  resource_group_name  = azurerm_resource_group.platform.name
  address_space        = ["10.0.0.0/16"]
  tags                 = local.common_tags
}

# =============================================================================
# Networking - Subnets
# =============================================================================

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

# =============================================================================
# Security - Key Vault
# =============================================================================

resource "azurerm_key_vault" "main" {
  name                        = var.key_vault_name
  location                    = var.location
  resource_group_name         = azurerm_resource_group.platform.name
  tenant_id                   = data.azurerm_client_config.current_user.tenant_id
  sku_name                    = "standard"
  rbac_authorization_enabled  = true
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false
  tags                        = local.common_tags
}

resource "azurerm_key_vault_secret" "test" {
  name          = "sample-secret"
  value         = var.secret_value # Have no purpose yet, just for testing
  key_vault_id  = azurerm_key_vault.main.id
  tags          = local.common_tags

  depends_on = [ azurerm_role_assignment.key_vault_access ]
}

# =============================================================================
# Security - RBAC
# =============================================================================

resource "azurerm_role_assignment" "key_vault_access" {
  scope                 = azurerm_resource_group.platform.id
  role_definition_name  = "Key Vault Secrets Officer"
  principal_id          = data.azurerm_client_config.current_user.object_id
}

resource "azurerm_role_assignment" "resource_group_reader" {
  scope                 = azurerm_resource_group.platform.id
  role_definition_name  = "Reader"
  principal_id          = azuread_group.readers.object_id
}

# =============================================================================
# Groups
# =============================================================================

resource "azuread_group" "readers" {
  display_name      = "rg-platform-readers"
  description       = "Read-only access to platform resource group"
  security_enabled  = true
  mail_enabled      = false
}

# =============================================================================
# Analytics & Logs - Storage
# =============================================================================

resource "azurerm_storage_account" "main" {
  name                        = var.storage_account_log_name
  resource_group_name         = azurerm_resource_group.platform.name
  location                    = var.location
  account_tier                = "Standard"
  account_replication_type    = "LRS"
  account_kind                = "StorageV2"
  https_traffic_only_enabled  = true
  tags                        = local.common_tags

  network_rules {
    default_action = "Deny"
    bypass         = ["AzureServices"]
  }
}

resource "azurerm_log_analytics_workspace" "main" {
  name                = var.log_analytics_name
  resource_group_name = azurerm_resource_group.platform.name
  location            = var.location
  sku                 = "PerGB2018"
  retention_in_days   = 30
  tags                = local.common_tags
}