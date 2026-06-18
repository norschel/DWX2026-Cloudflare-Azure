output "service_plan_name" {
  description = "The name of the App Service Plan used for hosting the web application."
  value       = azurerm_service_plan.demo.name
}

output "service_plan_id" {
  description = "The ID of the App Service Plan used for hosting the web application."
  value       = azurerm_service_plan.demo.id
}