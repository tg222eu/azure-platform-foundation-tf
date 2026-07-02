provider "azurerm" {
  features {
    log_analytics_workspace {
      permanently_delete_on_destroy = true
    }
  }
  
}