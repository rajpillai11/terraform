

provider "azurerm" {
    features {}
    subscription_id = "91553562-85e8-433d-bbc6-090bdde12ce9"   
}

resource "azurerm_resource_group" "example" {
    name     = "example-resources"
    location = var.location
}

resource "azurerm_virtual_network" "example" {
    name                = "example-vnet"
    address_space       = ["10.0.0.0/16"]
    location            = azurerm_resource_group.example.location
    resource_group_name = azurerm_resource_group.example.name
}

resource "azurerm_subnet" "example" {
    name                 = "example-subnet"
    resource_group_name  = azurerm_resource_group.example.name
    virtual_network_name = azurerm_virtual_network.example.name
    address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_network_interface" "example" {
    name                = "example-nic"
    location            = azurerm_resource_group.example.location
    resource_group_name = azurerm_resource_group.example.name

    ip_configuration {
        name                          = "internal"
        subnet_id                     = azurerm_subnet.example.id
        private_ip_address_allocation = "Dynamic"
    }
}

resource "azurerm_windows_virtual_machine" "example" {
    name                = "VM1"
    resource_group_name = azurerm_resource_group.example.name
    location            = azurerm_resource_group.example.location
    size                = var.sku
    admin_username      = "adminuser"
    admin_password      = "P@ssword1234!"
    network_interface_ids = [
        azurerm_network_interface.example.id,
    ]

    os_disk {
        caching              = "ReadWrite"
        storage_account_type = "Standard_LRS"
        name                 = "vm1-osdisk"
    }

    source_image_reference {
        publisher = "MicrosoftWindowsServer"
        offer     = "WindowsServer"
        sku       = "2019-Datacenter"
        version   = "latest"
    }
}





resource "azurerm_subnet" "firewallsubnet" {
  name                 = "AzureFirewallSubnet"
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_public_ip" "firewallip" {
  name                = "firewall-ip"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_firewall" "example" {
  name                = "testfirewall"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  sku_name            = "AZFW_VNet"
  sku_tier            = "Standard"

  ip_configuration {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.firewallsubnet.id
    public_ip_address_id = azurerm_public_ip.firewallip.id
  }
}