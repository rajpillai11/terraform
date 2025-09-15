variable "location" {
  description = "The Azure region to deploy resources in."
  type        = string
  default     = "East US"
  
}
variable "sku" {
  description = "The SKU of the virtual machine."
  type        = string
  default     = "Standard_DS1_v2"
  
}
variable "adminusername" {
  description = "The admin username for the virtual machine."
  type        = string
  default     = "adminuser"
  
}