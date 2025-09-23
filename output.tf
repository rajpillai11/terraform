output "virtual_machine_ip_address" {
  description = "The public IP address of PROD virtual machine."
  value       = azurerm_windows_virtual_machine.example
  sensitive = true
}