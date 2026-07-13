# =============================================================================
# Logs
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

# =============================================================================
# Monitor Diagnostic Settings
# =============================================================================

resource "azurerm_monitor_diagnostic_setting" "keyvault" {
    name                        = "keyvault-diagnostics"
    target_resource_id          = azurerm_key_vault.main.id
    log_analytics_workspace_id  = azurerm_log_analytics_workspace.main.id

    enabled_log {
        category = "AuditEvent"
    }

    enabled_metric {
        category = "AllMetrics"
    }
}

resource "azurerm_monitor_diagnostic_setting" "vnet" {
  name                        = "vnet-diagnostics"
  target_resource_id          = azurerm_virtual_network.hub.id
  log_analytics_workspace_id  = azurerm_log_analytics_workspace.main.id

  enabled_metric {
    category = "AllMetrics"
  }
}

resource "azurerm_monitor_diagnostic_setting" "nsg_app" {
  name                        = "nsg-diagnostics"
  target_resource_id          = azurerm_network_security_group.app.id
  log_analytics_workspace_id  = azurerm_log_analytics_workspace.main.id

  enabled_log {
    category = "allLogs"
  }
}

resource "azurerm_monitor_diagnostic_setting" "nsg_data" {
  name                        = "nsg-diagnostics"
  target_resource_id          = azurerm_network_security_group.data.id
  log_analytics_workspace_id  = azurerm_log_analytics_workspace.main.id

  enabled_log {
    category = "allLogs"
  }
}

resource "azurerm_monitor_diagnostic_setting" "nsg_mgmt" {
  name                        = "nsg-diagnostics"
  target_resource_id          = azurerm_network_security_group.mgmt.id
  log_analytics_workspace_id  = azurerm_log_analytics_workspace.main.id

  enabled_log {
    category = "allLogs"
  }
}

resource "azurerm_monitor_diagnostic_setting" "storage" {
  name = "storage-diagnostics"
  target_resource_id          = azurerm_storage_account.main.id
  log_analytics_workspace_id  = azurerm_log_analytics_workspace.main.id

  enabled_log {
    category = "StorageRead"
  }

  enabled_log {
    category = "StorageWrite"
  }

  enabled_log {
    category = "StorageDelete"
  }

  enabled_metric {
    category = "AllMetrics"
  }

}