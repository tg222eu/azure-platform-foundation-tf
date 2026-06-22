terraform {
  backend "azurerm" {
    resource_group_name  = "rg-terraform-state"
    storage_account_name = "stterraformstate9482"
    container_name       = "tfstate"
    key                  = "platform-foundation.tfstate"
  }
}

resource "azurerm_resource_group" "platform" {
  name      = var.platform_resource_group_name
  location  = var.location
  tags      = local.common_tags
}

# ==========================================
# Networking - VNet
# ==========================================

resource "azurerm_virtual_network" "hub" {
  name                 = var.virtual_network_name
  location             = var.location
  resource_group_name  = azurerm_resource_group.platform.name
  address_space        = ["10.0.0.0/16"]
  tags                 = local.common_tags
}

# ==========================================
# Networking - Subnets
# ==========================================

resource "azurerm_subnet" "app" {
  name                  = var.app_subnet_name
  virtual_network_name  = azurerm_virtual_network.hub.name
  resource_group_name   = azurerm_resource_group.platform.name
  address_prefixes      = [var.app_subnet_address_prefix]
  depends_on            = [azurerm_virtual_network.hub]
}

resource "azurerm_subnet" "data" {
  name                  = var.data_subnet_name
  virtual_network_name  = azurerm_virtual_network.hub.name
  resource_group_name   = azurerm_resource_group.platform.name
  address_prefixes      = [var.data_subnet_address_prefix]
  depends_on            = [azurerm_virtual_network.hub]
}

resource "azurerm_subnet" "mgmt" {
  name                  = var.management_subnet_name
  virtual_network_name  = azurerm_virtual_network.hub.name
  resource_group_name   = azurerm_resource_group.platform.name
  address_prefixes      = [var.management_subnet_address_prefix]
  depends_on            = [azurerm_virtual_network.hub]
}

# ==========================================
# Networking - NSGs
# ==========================================

resource "azurerm_network_security_group" "app" {
  name                  = var.app_nsg_name
  location              = var.location
  resource_group_name   = var.platform_resource_group_name
  depends_on            = [azurerm_virtual_network.hub]
  tags                  = local.common_tags
}

resource "azurerm_network_security_group" "data" {
  name                  = var.data_nsg_name
  location              = var.location
  resource_group_name   = var.platform_resource_group_name
  depends_on            = [azurerm_virtual_network.hub]
  tags                  = local.common_tags
}

resource "azurerm_network_security_group" "mgmt" {
  name                  = var.mgmt_nsg_name
  location              = var.location
  resource_group_name   = var.platform_resource_group_name
  depends_on            = [azurerm_virtual_network.hub]
  tags                  = local.common_tags
}

# ==========================================
# Networking - NSG Associations
# ==========================================

resource "azurerm_subnet_network_security_group_association" "app" {
  subnet_id                   = azurerm_subnet.app.id
  network_security_group_id   = azurerm_network_security_group.app.id
}

resource "azurerm_subnet_network_security_group_association" "data" {
  subnet_id                   = azurerm_subnet.data.id
  network_security_group_id   = azurerm_network_security_group.data.id
}

resource "azurerm_subnet_network_security_group_association" "mgmt" {
  subnet_id                   = azurerm_subnet.mgmt.id
  network_security_group_id   = azurerm_network_security_group.mgmt.id
}

# ==========================================
# Networking - Security Rules
# ==========================================

resource "azurerm_network_security_rule" "app_deny_internet" {
  name                        = "Deny-All-Inbound-From-Internet"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Deny"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "Internet"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.platform.name
  network_security_group_name = azurerm_network_security_group.app.name
  description                 = "Deny all inbound traffic from the internet to app subnet"
}

resource "azurerm_network_security_rule" "data_deny_internet" {
  name                        = "Deny-All-Inbound-From-Internet"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Deny"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "Internet"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.platform.name
  network_security_group_name = azurerm_network_security_group.data.name
  description                 = "Deny all inbound traffic from the internet to data subnet"
}

resource "azurerm_network_security_rule" "mgmt_allow_rdp" {
  name                        = "Allow-RDP-3389-From-IP"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "TCP"
  source_port_range           = "*"
  destination_port_range      = "3389"
  source_address_prefix       = var.my_public_ip
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.platform.name
  network_security_group_name = azurerm_network_security_group.mgmt.name
  description                 = "Allow RDP from specific IP"
}

resource "azurerm_network_security_rule" "mgmt_allow_ssh" {
  name                        = "Allow-SSH-22-From-IP"
  priority                    = 110
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "TCP"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = var.my_public_ip
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.platform.name
  network_security_group_name = azurerm_network_security_group.mgmt.name
  description                 = "Allow SSH from specific IP"
}