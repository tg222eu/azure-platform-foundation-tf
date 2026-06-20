#<resource>-<project>-<env>

variable "location" {
    description = "Azure region"
    type        = string
    default     = "Sweden Central"
}

variable "platform_resource_group_name"{
    description = "Resource group"
    type        = string
    default     = "rg-platform-dev"
}

variable "virtual_network_name"{
    description = "App subnet"
    type        = string
    default     = "vnet-platform-dev"
}

##########SUBNETS###########

variable "app_subnet_name"{
    description = "App subnet name"
    type        = string
    default     = "snet-app-platform-dev"
}

variable "data_subnet_name"{
    description = "Data subnet name"
    type        = string
    default     = "snet-data-platform-dev"
}

variable "management_subnet_name"{
    description = "Management subnet name"
    type        = string
    default     = "snet-mgmt-platform-dev"
}

variable "app_subnet_address_prefix"{
    description = "App subnet address prefix"
    type        = string
    default     = "10.0.1.0/24"
}

variable "data_subnet_address_prefix"{
    description = "Data subnet address prefix"
    type        = string
    default     = "10.0.2.0/24"
}

variable "management_subnet_address_prefix"{
    description = "Management address prefix"
    type        = string
    default     = "10.0.3.0/24"
}

######## NSG #########

variable "app_nsg_name"{
    description = "App NSG"
    type        = string
    default     = "nsg-app-platform-dev"
}

variable "data_nsg_name"{
    description = "Data NSG"
    type        = string
    default     = "nsg-data-platform-dev"
}

variable "mgmt_nsg_name"{
    description = "Management NSG"
    type        = string
    default     = "nsg-mgmt-platform-dev"
}