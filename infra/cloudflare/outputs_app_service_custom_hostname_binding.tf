output "app_service_custom_hostname_binding_id" {
  description = "The ID of the App Service Custom Hostname Binding"
  value       = azurerm_app_service_custom_hostname_binding.demo.id
}

output "app_service_custom_hostname_binding_virtual_ip" {
  description = "The virtual IP address assigned to the hostname if IP based SSL is enabled."
  value       = azurerm_app_service_custom_hostname_binding.demo.virtual_ip
}