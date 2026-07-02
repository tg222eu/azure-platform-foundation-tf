provider "azurerm" {
  features {
    log_analytics_workspace {
      permanently_delete_on_destroy = true
    }
    key_vault {
      purge_soft_delete_on_destroy    = true
      recover_soft_deleted_key_vaults = false

      purge_soft_deleted_secrets_on_destroy = true
      recover_soft_deleted_secrets          = false
    }
  }
  
}