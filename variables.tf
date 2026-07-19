# =============================================================================
# VARIABLES - Platform Foundation
# =============================================================================

variable "location" {
    description = "Azure region"
    type        = string
    default     = "Sweden Central"
}

# =============================================================================
# TAGS
# =============================================================================
variable "environment_name" {
    description = "Environment name (dev, test, prod)"
    type        = string
    default     = "dev"
}

variable "project_name" {
    description = "Project name"
    type        = string
    default     = "platform"
}

variable "owner_name" {
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
# ALERT
# =============================================================================

variable "alert_email" {
    description = "Email which alerts are sent to"
    type = string
    default = "example@example.com"
}

# =============================================================================
# SUBNETS
# =============================================================================

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
# SECURITY & KEYS
# =============================================================================

variable "my_public_ip" {
  description = "My public IP"
  type        = string
  # IP stored locally
}

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
