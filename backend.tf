terraform {
  backend "azurerm" {
    resource_group_name   = "tf-rg"
    storage_account_name  = "satfstate2907"
    container_name        = "tf-blob"
    key                   = "main.terraform.tfstate"
  }
}