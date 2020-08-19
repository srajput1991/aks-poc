####################
# Provider section #
####################
provider "azurerm" {
  version = ">= 2.0.0"
  features {}
}
#####################
# Resources section #
#####################
resource "azurerm_virtual_network" "network" {
  name                = "${var.resource_prefix}-vnet"
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = var.vnet_address_space
  #dns_servers         = var.dns_servers

  subnet {
    name           = "${var.resource_prefix}-subnet"
    address_prefix = cidrsubnet(tostring(join(", ", var.vnet_address_space)), 4, 0)
  }
  tags = {
    environment = var.tags
  }
}
