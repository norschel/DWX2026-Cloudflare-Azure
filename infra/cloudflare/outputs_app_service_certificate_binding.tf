output "app_service_certificate_binding_id" {
  description = "The ID of the App Service Certificate Binding."
  value       = azurerm_app_service_certificate_binding.demo.id
}

output "app_service_certificate_binding_app_service_name" {
  description = "The name of the App Service associated with the Certificate Binding."
  value       = azurerm_app_service_certificate_binding.demo.app_service_name
}

output "app_service_certificate_binding_hostname" {
  description = "The hostname of the App Service associated with the Certificate Binding."
  value       = azurerm_app_service_certificate_binding.demo.hostname
}

output "app_service_certificate_binding_thumbprint" {
  description = "The thumbprint of the App Service Certificate associated with the Certificate Binding."
  value       = azurerm_app_service_certificate_binding.demo.thumbprint
}