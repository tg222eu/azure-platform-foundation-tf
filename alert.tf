# =============================================================================
# Action Group
# =============================================================================

resource "azurerm_monitor_action_group" "platform_alerts" {
    name = "alerts-platform-dev"
    resource_group_name = azurerm_resource_group.platform.name
    short_name = "plat-alerts"

    email_receiver {
      name = "platform-email"
      email_address = var.alert_email
      use_common_alert_schema = true
    }
    
    tags = local.common_tags
}

# =============================================================================
# Keyvault
# =============================================================================

resource "azurerm_monitor_activity_log_alert" "key_vault_changes" {
    name                = "${local.naming_prefix}-kv-secret-changes"
    resource_group_name = azurerm_resource_group.platform
    scopes              = [azurerm_key_vault.main.id]
    location = "Global"

    criteria {
        category = "Administrative"
        operation_name = "Microsoft.KeyVault/vaults/secrets/*"
    }

    action {
        action_group_id = azurerm_monitor_action_group.platform_alerts.id
    }
}

# =============================================================================
# Budget
# =============================================================================

resource azurerm_consumption_budget_resource_group "platform_budget_exceeded" {
    name                = var.consumption_budget_name
    resource_group_id   = azurerm_resource_group.platform
    time_grain          = "Monthly"
    amount              = 100 # SEK currency

    time_period {
      start_date = formatdate("YYYY-MM-01'T'00:00:00Z", timestamp())
    }

    notification {
        enabled = true
        threshold = 5
        operator = "GreaterThan"
        contact_emails = [var.alert_email]
        contact_groups = [azurerm_monitor_action_group.platform_alerts.id]
    }

    notification {
        enabled = true
        threshold = 15
        operator = "GreaterThan"
        contact_emails = [var.alert_email]
        contact_groups = [azurerm_monitor_action_group.platform_alerts.id]
    }

    notification {
        enabled = true
        threshold = 40
        operator = "GreaterThan"
        contact_emails = [var.alert_email]
        contact_groups = [azurerm_monitor_action_group.platform_alerts.id]
    }
    
    notification {
        enabled = true
        threshold = 70
        operator = "GreaterThan"
        contact_emails = [var.alert_email]
        contact_groups = [azurerm_monitor_action_group.platform_alerts.id]
    }

    notification {
        enabled = true
        threshold = 100
        operator = "GreaterThan"
        contact_emails = [var.alert_email]
        contact_groups = [azurerm_monitor_action_group.platform_alerts.id]
    }

depends_on = [azurerm_monitor_action_group.platform_alerts]
}