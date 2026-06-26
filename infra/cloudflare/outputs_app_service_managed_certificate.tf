output "app_service_managed_certificate_id" {
  description = "The ID of the App Service Managed Certificate."
  value       = azurerm_app_service_managed_certificate.demo.id
}

output "app_service_managed_certificate_canonical_name" {
  description = "The canonical name of the App Service Managed Certificate."
  value       = azurerm_app_service_managed_certificate.demo.canonical_name
}

output "app_service_managed_certificate_host_names" {
  description = "The host names of the App Service Managed Certificate."
  value       = azurerm_app_service_managed_certificate.demo.host_names
}

output "app_service_managed_certificate_friendly_name" {
  description = "The friendly name of the App Service Managed Certificate."
  value       = azurerm_app_service_managed_certificate.demo.friendly_name
}