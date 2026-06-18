output "resource_group_name" {
  description = "The name of the Resource Group where all resources are deployed."
  value       = azurerm_resource_group.demo.name
}

output "resource_group_id" {
  description = "The ID of the Resource Group where all resources are deployed."
  value       = azurerm_resource_group.demo.id
}