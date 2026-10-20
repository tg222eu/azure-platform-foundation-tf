# =============================================================================
# MAIN - Platform Foundation
# =============================================================================

terraform {
  backend "azurerm" {
    resource_group_name  = "rg-terraform-state"
    storage_account_name = "stterraformstate9482"
    container_name       = "tfstate"
    key                  = "platform-foundation.tfstate"

    use_azuread_auth = true
    use_oidc         = true
  }
}

# Only used for initial setup of the project
data "azurerm_client_config" "current_user" {}

data "azuread_service_principal" "github_oidc" { client_id = "c55e44ef-dddd-4bae-ba0f-edf101ba2363" }

resource "azurerm_resource_group" "main" {
  name     = "${local.naming_prefix}-resource-group"
  location = var.location
  tags     = local.common_tags
}

# =============================================================================
# Networking - VNet
# =============================================================================

resource "azurerm_virtual_network" "hub" {
  name                = "${local.naming_prefix}-vnet"
  location            = var.location
  resource_group_name = azurerm_resource_group.main.name
  address_space       = ["10.0.0.0/16"]
  tags                = local.common_tags
}

# =============================================================================
# Networking - Subnets
# =============================================================================

resource "azurerm_subnet" "app" {
  name                 = "${local.naming_prefix}-snet-app"
  virtual_network_name = azurerm_virtual_network.hub.name
  resource_group_name  = azurerm_resource_group.main.name
  address_prefixes     = [var.app_subnet_address_prefix]
}

resource "azurerm_subnet" "data" {
  name                 = "${local.naming_prefix}-snet-data"
  virtual_network_name = azurerm_virtual_network.hub.name
  resource_group_name  = azurerm_resource_group.main.name
  address_prefixes     = [var.data_subnet_address_prefix]
}

resource "azurerm_subnet" "mgmt" {
  name                 = "${local.naming_prefix}-snet-mgmt"
  virtual_network_name = azurerm_virtual_network.hub.name
  resource_group_name  = azurerm_resource_group.main.name
  address_prefixes     = [var.management_subnet_address_prefix]
}

# =============================================================================
# Security - Key Vault
# =============================================================================

resource "azurerm_key_vault" "main" {
  name                       = var.key_vault_name
  location                   = var.location
  resource_group_name        = azurerm_resource_group.main.name
  tenant_id                  = data.azurerm_client_config.current_user.tenant_id
  sku_name                   = "standard"
  rbac_authorization_enabled = true
  soft_delete_retention_days = 7
  purge_protection_enabled   = false
  tags                       = local.common_tags
}

resource "azurerm_key_vault_secret" "main" {
  name         = "secret"
  value        = var.key_secret_value # Have no purpose yet, just for testing
  key_vault_id = azurerm_key_vault.main.id
  tags         = local.common_tags

  depends_on = [azurerm_role_assignment.key_vault_access]
}

# =============================================================================
# Security - RBAC
# =============================================================================

resource "azurerm_role_assignment" "key_vault_access" {
  scope                = azurerm_resource_group.main.id
  role_definition_name = "Key Vault Secrets Officer"
  principal_id         = "899ce21f-3c84-4fae-95a7-c0f161e6f34b"
}

resource "azurerm_role_assignment" "resource_group_reader" {
  scope                = azurerm_resource_group.main.id
  role_definition_name = "Reader"
  principal_id         = "899ce21f-3c84-4fae-95a7-c0f161e6f34b"
}

# Lets GitHub Action manage the resources inside main resource group
resource "azurerm_role_assignment" "resource_group_contributor" {
  scope                = azurerm_resource_group.main.id
  role_definition_name = "Contributor"
  principal_id         = data.azuread_service_principal.github_oidc.object_id
}

# =============================================================================
# Groups
# =============================================================================

resource "azuread_group" "readers" {
  display_name     = "${local.naming_prefix}-readers"
  description      = "Read-only access to main resource group"
  security_enabled = true
  mail_enabled     = false
}
