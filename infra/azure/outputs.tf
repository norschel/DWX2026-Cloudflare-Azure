output "resource_group_name" {
  value = azurerm_resource_group.demo.name
}

output "app_hostname" {
  value = azurerm_linux_web_app.demo.default_hostname
}

output "health_url" {
  value = "https://${azurerm_linux_web_app.demo.default_hostname}/api/health"
}

output "application_insights_connection_string" {
  value     = azurerm_application_insights.demo.connection_string
  sensitive = true
}
