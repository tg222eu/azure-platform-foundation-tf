# =============================================================================
# Logs
# =============================================================================

resource "azurerm_storage_account" "main" {
  name                        = var.storage_account_log_name
  resource_group_name         = azurerm_resource_group.main.name
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
  name                = "${local.naming_prefix}-log"
  resource_group_name = azurerm_resource_group.main.name
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

    enabled_log { category = "AuditEvent" }
    enabled_metric { category = "AllMetrics" }
}

resource "azurerm_monitor_diagnostic_setting" "storage" {
  name                        = "storage-diagnostics"
  target_resource_id          = azurerm_storage_account.main.id
  log_analytics_workspace_id  = azurerm_log_analytics_workspace.main.id

  enabled_metric { category = "AllMetrics" }
}

resource "azurerm_monitor_diagnostic_setting" "storage_blob" {
  name                        = "storage-blob-diagnostics"
  target_resource_id          = "${azurerm_storage_account.main.id}/blobServices/default"
  log_analytics_workspace_id  = azurerm_log_analytics_workspace.main.id

  enabled_metric { category = "AllMetrics" }
}