output "linux_web_app_id" {
  description = "The ID of the Linux Web App used for hosting the web application."
  value       = azurerm_linux_web_app.demo.id
}

output "linux_web_app_name" {
  description = "The name of the Linux Web App used for hosting the web application."
  value       = azurerm_linux_web_app.demo.name
}

output "linux_web_app_default_hostname" {
  description = "The default hostname of the Linux Web App."
  value       = azurerm_linux_web_app.demo.default_hostname
}

output "linux_web_app_health_url" {
  description = "The health URLof the Linux Web App."
  value       = "https://${azurerm_linux_web_app.demo.default_hostname}/api/health"
}
