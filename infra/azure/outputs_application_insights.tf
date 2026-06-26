output "application_insights_name" {
  description = "The name of the Application Insights resource used for monitoring the web application."
  value       = azurerm_application_insights.demo.name
}

output "application_insights_id" {
  description = "The ID of the Application Insights resource used for monitoring the web application."
  value       = azurerm_application_insights.demo.id
}

output "application_insights_connection_string" {
  description = "The connection string of the Application Insights resource used for monitoring the web application. This value is marked as sensitive to prevent it from being displayed in plain text in logs and outputs."
  value       = azurerm_application_insights.demo.connection_string
  sensitive   = true
}