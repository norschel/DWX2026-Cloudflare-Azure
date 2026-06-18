output "log_analytics_workspace_name" {
  description = "The name of the Log Analytics Workspace used for monitoring and diagnostics."
  value       = azurerm_log_analytics_workspace.demo.name
}

output "log_analytics_workspace_id" {
  description = "The ID of the Log Analytics Workspace used for monitoring and diagnostics."
  value       = azurerm_log_analytics_workspace.demo.id
}