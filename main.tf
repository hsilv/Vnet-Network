provider "azurerm" {
  features {}

  subscription_id = "bd840cfe-92ce-45ce-8710-1168a88f5c80"
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

resource "azurerm_subnet" "ventas" {
  name                 = "ventas"
  resource_group_name  = azurerm_resource_group.vnetGroup.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["193.65.72.0/27"]
}

resource "azurerm_subnet" "ti" {
  name                 = "ti"
  resource_group_name  = azurerm_resource_group.vnetGroup.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["193.65.72.32/28"]
}

resource "azurerm_subnet" "datacenter" {
  name                 = "datacenter"
  resource_group_name  = azurerm_resource_group.vnetGroup.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["193.65.72.48/29"]
}

resource "azurerm_subnet" "internet" {
  name                 = "internet"
  resource_group_name  = azurerm_resource_group.vnetGroup.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["193.65.72.56/29"]
}

resource "azurerm_subnet" "visitors" {
  name                 = "visitors"
  resource_group_name  = azurerm_resource_group.vnetGroup.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["193.65.72.64/26"]
}

resource "azurerm_network_security_group" "ventas_nsg" {
  name                = "ventas-nsg"
  location            = azurerm_resource_group.vnetGroup.location
  resource_group_name = azurerm_resource_group.vnetGroup.name

  security_rule {
    name                       = "AllowSSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_security_group" "ti_nsg" {
  name                = "ti-nsg"
  location            = azurerm_resource_group.vnetGroup.location
  resource_group_name = azurerm_resource_group.vnetGroup.name

  security_rule {
    name                       = "AllowSSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_security_group" "datacenter_nsg" {
  name                = "datacenter-nsg"
  location            = azurerm_resource_group.vnetGroup.location
  resource_group_name = azurerm_resource_group.vnetGroup.name

  security_rule {
    name                       = "AllowSSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_security_group" "visitors_nsg" {
  name                = "visitors-nsg"
  location            = azurerm_resource_group.vnetGroup.location
  resource_group_name = azurerm_resource_group.vnetGroup.name

  security_rule {
    name                       = "AllowSSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_subnet_network_security_group_association" "ventas_nsg_association" {
  subnet_id                 = azurerm_subnet.ventas.id
  network_security_group_id = azurerm_network_security_group.ventas_nsg.id
}

resource "azurerm_subnet_network_security_group_association" "ti_nsg_association" {
  subnet_id                 = azurerm_subnet.ti.id
  network_security_group_id = azurerm_network_security_group.ti_nsg.id
}

resource "azurerm_subnet_network_security_group_association" "datacenter_nsg_association" {
  subnet_id                 = azurerm_subnet.datacenter.id
  network_security_group_id = azurerm_network_security_group.datacenter_nsg.id
}

resource "azurerm_subnet_network_security_group_association" "visitors_nsg_association" {
  subnet_id                 = azurerm_subnet.visitors.id
  network_security_group_id = azurerm_network_security_group.visitors_nsg.id
}

resource "azurerm_network_interface" "vm_nic_ventas" {
  count               = var.vm_count_ventas
  name                = "vm-nic-ventas-${count.index}"
  location            = azurerm_resource_group.vnetGroup.location
  resource_group_name = azurerm_resource_group.vnetGroup.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.ventas.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_network_interface" "vm_nic_ti" {
  count               = var.vm_count_ti
  name                = "vm-nic-ti-${count.index}"
  location            = azurerm_resource_group.vnetGroup.location
  resource_group_name = azurerm_resource_group.vnetGroup.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.ti.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_network_interface" "vm_nic_datacenter" {
  count               = var.vm_count_datacenter
  name                = "vm-nic-datacenter-${count.index}"
  location            = azurerm_resource_group.vnetGroup.location
  resource_group_name = azurerm_resource_group.vnetGroup.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.datacenter.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_network_interface" "vm_nic_visitors" {
  count               = var.vm_count_visitors
  name                = "vm-nic-visitors-${count.index}"
  location            = azurerm_resource_group.vnetGroup.location
  resource_group_name = azurerm_resource_group.vnetGroup.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.visitors.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_virtual_machine" "vm_ventas" {
  count                = var.vm_count_ventas
  name                 = "vm-ventas-${count.index}"
  location             = azurerm_resource_group.vnetGroup.location
  resource_group_name  = azurerm_resource_group.vnetGroup.name
  network_interface_ids = [azurerm_network_interface.vm_nic_ventas[count.index].id]
  vm_size              = "Standard_B2pls_v2"

  storage_os_disk {
    name              = "osdisk-ventas-${count.index}"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18_04-lts-arm64"
    version   = "18.04.202401161"
  }

  os_profile {
    computer_name  = "hostname-ventas-${count.index}"
    admin_username = var.admin_username
    admin_password = var.admin_password
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }
}

resource "azurerm_virtual_machine" "vm_ti" {
  count                = var.vm_count_ti
  name                 = "vm-ti-${count.index}"
  location             = azurerm_resource_group.vnetGroup.location
  resource_group_name  = azurerm_resource_group.vnetGroup.name
  network_interface_ids = [azurerm_network_interface.vm_nic_ti[count.index].id]
  vm_size              = "Standard_B2pls_v2"

  storage_os_disk {
    name              = "osdisk-ti-${count.index}"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18_04-lts-arm64"
    version   = "18.04.202401161"
  }

  os_profile {
    computer_name  = "hostname-ti-${count.index}"
    admin_username = var.admin_username
    admin_password = var.admin_password
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }
}

resource "azurerm_virtual_machine" "vm_datacenter" {
  count                = var.vm_count_datacenter
  name                 = "vm-datacenter-${count.index}"
  location             = azurerm_resource_group.vnetGroup.location
  resource_group_name  = azurerm_resource_group.vnetGroup.name
  network_interface_ids = [azurerm_network_interface.vm_nic_datacenter[count.index].id]
  vm_size              = "Standard_B2pls_v2"

  storage_os_disk {
    name              = "osdisk-datacenter-${count.index}"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18_04-lts-arm64"
    version   = "18.04.202401161"
  }

  os_profile {
    computer_name  = "hostname-datacenter-${count.index}"
    admin_username = var.admin_username
    admin_password = var.admin_password
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }
}

resource "azurerm_virtual_machine" "vm_visitors" {
  count                = var.vm_count_visitors
  name                 = "vm-visitors-${count.index}"
  location             = azurerm_resource_group.vnetGroup.location
  resource_group_name  = azurerm_resource_group.vnetGroup.name
  network_interface_ids = [azurerm_network_interface.vm_nic_visitors[count.index].id]
  vm_size              = "Standard_B2pls_v2"

  storage_os_disk {
    name              = "osdisk-visitors-${count.index}"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18_04-lts-arm64"
    version   = "18.04.202401161"
  }

  os_profile {
    computer_name  = "hostname-visitors-${count.index}"
    admin_username = var.admin_username
    admin_password = var.admin_password
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }
}