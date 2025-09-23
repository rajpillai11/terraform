

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
    location            = var.location
    resource_group_name = azurerm_resource_group.example.name
}

resource "azurerm_subnet" "example" {
    name                 = "example-subnet"
    resource_group_name  = azurerm_resource_group.example.name
    virtual_network_name = azurerm_virtual_network.example.name
    address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_network_interface" "example" {
    name                = "example-nic-${count.index}"
    location            = var.location
    resource_group_name = azurerm_resource_group.example.name
    count =     2

    ip_configuration {
        name                          = "internal-${count.index}"
        subnet_id                     = azurerm_subnet.example.id
        private_ip_address_allocation = "Dynamic"
    
    }
    
}

resource "azurerm_windows_virtual_machine" "example" {
    name                = "VM-${count.index}"
    resource_group_name = azurerm_resource_group.example.name
    location            = var.location
    size                = var.sku
    admin_username      = var.adminusername
    admin_password      = var.admin_password
    network_interface_ids = [
        azurerm_network_interface.example[count.intex].id,
    ]
    count =2
    os_disk {
        caching              = "ReadWrite"
        storage_account_type = "Standard_LRS"
        name                 = "vm-${count.index}-osdisk"
    }

    source_image_reference {
        publisher = "MicrosoftWindowsServer"
        offer     = "WindowsServer"
        sku       = "2019-Datacenter"
        version   = "latest"
    }
    
}





