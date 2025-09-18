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
resource "azurerm_virtual_network" "example2" {
    name                = "example-vnet-2"
    address_space       = ["10.1.0.0/16"]
    location            = var.location
    resource_group_name = azurerm_resource_group.example.name
}
    resource "azurerm_resource_group" "tf-rg" {
  name     = "rg-terraform-state"
  location = var.location
}

resource "azurerm_storage_account" "tf-sa" {
  name                     = "satfstate2907"
  resource_group_name      = azurerm_resource_group.example.name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "GRS"

}
resource "azurerm_storage_container" "tf-blob" {
  name                  = "tf-state"
  storage_account_id    = azurerm_storage_account.tf-sa.id
  container_access_type = "private"
}