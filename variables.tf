# =============================================================================
# VARIABLES - Platform Foundation
# =============================================================================
# Naming conversion<resource>-<project>-<env>
# All variables are declared here
# =============================================================================

variable "location" {
    description = "Azure region"
    type        = string
    default     = "Sweden Central"
}

variable "platform_resource_group_name" {
    description = "Resource group"
    type        = string
    default     = "rg-platform-dev"
}

variable "virtual_network_name" {
    description = "App subnet"
    type        = string
    default     = "vnet-platform-dev"
}

variable "consumption_budget_name" {
    description = "Budget consumption name"
    type = string
    default = "budget-platform-dev"
}

variable "alert_email" {
    description = "Email which alerts are sent to"
    type = string
    default = "example@example.com"
}

# =============================================================================
# SUBNETS
# =============================================================================

variable "app_subnet_name" {
    description = "App subnet name"
    type        = string
    default     = "snet-app-platform-dev"
}

variable "data_subnet_name" {
    description = "Data subnet name"
    type        = string
    default     = "snet-data-platform-dev"
}

variable "management_subnet_name" {
    description = "Management subnet name"
    type        = string
    default     = "snet-mgmt-platform-dev"
}

variable "app_subnet_address_prefix" {
    description = "App subnet address prefix"
    type        = string
    default     = "10.0.1.0/24"
}

variable "data_subnet_address_prefix" {
    description = "Data subnet address prefix"
    type        = string
    default     = "10.0.2.0/24"
}

variable "management_subnet_address_prefix" {
    description = "Management address prefix"
    type        = string
    default     = "10.0.3.0/24"
}

# =============================================================================
# NSG
# =============================================================================

variable "app_nsg_name" {
    description = "App NSG"
    type        = string
    default     = "nsg-app-platform-dev"
}

variable "data_nsg_name" {
    description = "Data NSG"
    type        = string
    default     = "nsg-data-platform-dev"
}

variable "mgmt_nsg_name" {
    description = "Management NSG"
    type        = string
    default     = "nsg-mgmt-platform-dev"
}

# =============================================================================
# TAGS
# =============================================================================

variable "environment" {
    description = "Environment name (dev, test, prod)" # test/prod not used yet
    type        = string
    default     = "dev"
}

variable "owner" {
    description = "Owner name"
    type        = string
    default     = "Thorvald"
}

variable "cost_center" {
    description = "Cost center for billing"
    type        = string
    default     = "IT-Platform"
}

# =============================================================================
# SECURITY RULES VARIABLES
# =============================================================================

variable "my_public_ip" {
  description = "My public IP"
  type        = string
  # IP stored locally
}

# =============================================================================
# KEYS
# =============================================================================

variable "key_vault_name" {
  description = "Key vault name"
  type        = string
  # Key vault value stored locally
}

variable "secret_value" {
  description = "Key name"
  type        = string
  sensitive   = true
  # Key value stored locally
}

# =============================================================================
# LOG STORAGE
# =============================================================================

variable "storage_account_log_name" {
    description = "Name of log storage accoount"
    type        = string
    # Name stored locally
}

variable "log_analytics_name" {
  description = "Name of log analytics"
  type        = string
  default     = "log-platform-dev"
}