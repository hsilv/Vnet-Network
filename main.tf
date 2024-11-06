provider "azurerm" {
    features {}
}

resource "azurerm_resource_group" "vnetGroup" {
  name     = "UVG_Vnet"
  location = "East US"
}

resource "azurerm_virtual_network" "vnet" {
  name                = "UVG_Vnet"
  resource_group_name = azurerm_resource_group.vnetGroup.name
  location            = azurerm_resource_group.vnetGroup.location
 address_space       = ["193.65.72.0/24"]
}

resource "azurerm_subnet" "internet" {
  name                 = "internet"
  resource_group_name  = azurerm_resource_group.vnetGroup.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["193.65.72.104/29"]
}

resource "azurerm_subnet" "sales" {
  name                 = "sales"
  resource_group_name  = azurerm_resource_group.vnetGroup.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["193.65.72.0/28"]
}

resource "azurerm_subnet" "it" {
  name                 = "it"
  resource_group_name  = azurerm_resource_group.vnetGroup.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["193.65.72.16/28"]
}

resource "azurerm_subnet" "datacenter" {
  name                 = "datacenter"
  resource_group_name  = azurerm_resource_group.vnetGroup.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["193.65.72.32/29"]
}

resource "azurerm_subnet" "visitors" {
  name                 = "visitors"
  resource_group_name  = azurerm_resource_group.vnetGroup.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["193.65.72.40/26"]
}
