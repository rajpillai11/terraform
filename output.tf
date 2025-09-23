output "Virtual_Machine_IP address" {
  description = "The public IP address of PROD virtual machine."
  value       = azurerm_windows_virtual_machine.example.public_ip_address
}