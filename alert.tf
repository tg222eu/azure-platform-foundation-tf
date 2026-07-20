# =============================================================================
# Action Group
# =============================================================================

resource "azurerm_monitor_action_group" "main" {
    name                    = "${local.naming_prefix}-alerts"
    resource_group_name     = azurerm_resource_group.main.name
    short_name              = "ag-alerts"

/*
    email_receiver {
      name                      = "platform-email"
      email_address             = var.alert_email
      use_common_alert_schema   = true
    }
*/
    webhook_receiver {
      name                      = "webhook-test"
      service_uri               = "https://webhook.site/63d16022-3c7f-4ec2-8352-24d90ea8ec1a"
      use_common_alert_schema   = true
    }
    
    tags = local.common_tags
}

# =============================================================================
# Keyvault
# =============================================================================

resource "azurerm_monitor_scheduled_query_rules_alert_v2" "kv_secret_get" {
    name                        = "${local.naming_prefix}-kv-secret-get"
    resource_group_name         = azurerm_resource_group.main.name
    location                    = var.location
    evaluation_frequency        = "PT5M"
    window_duration             = "PT5M"
    scopes                      = [azurerm_log_analytics_workspace.main.id]
    severity                    = 2

    criteria {
      query = <<-QUERY
        AzureDiagnostics
        | where OperationName == "SecretGet"
    QUERY
    time_aggregation_method = 0
    threshold = 0
    operator = GreaterThan
    }

    action {
      action_groups = [azurerm_monitor_action_group.main.id]
    }
    tags = local.common_tags
}

# =============================================================================
# Budget
# =============================================================================

resource azurerm_consumption_budget_resource_group "project_budget_exceeded" {
    name                = "${local.naming_prefix}-consumption"
    resource_group_id   = azurerm_resource_group.main.id
    time_grain          = "Monthly"
    amount              = 100 # SEK currency

    time_period {
      start_date = formatdate("YYYY-MM-01'T'00:00:00Z", timestamp())
    }

    notification {
        enabled         = true
        threshold       = 5
        operator        = "GreaterThan"
        contact_emails  = [var.alert_email]
        contact_groups  = [azurerm_monitor_action_group.main.id]
    }

    notification {
        enabled         = true
        threshold       = 15
        operator        = "GreaterThan"
        contact_emails  = [var.alert_email]
        contact_groups  = [azurerm_monitor_action_group.main.id]
    }

    notification {
        enabled = true
        threshold       = 40
        operator        = "GreaterThan"
        contact_emails  = [var.alert_email]
        contact_groups  = [azurerm_monitor_action_group.main.id]
    }
    
    notification {
        enabled         = true
        threshold       = 70
        operator        = "GreaterThan"
        contact_emails  = [var.alert_email]
        contact_groups  = [azurerm_monitor_action_group.main.id]
    }

    notification {
        enabled = true
        threshold       = 100
        operator        = "GreaterThan"
        contact_emails  = [var.alert_email]
        contact_groups  = [azurerm_monitor_action_group.main.id]
    }

depends_on = [azurerm_monitor_action_group.main]
}