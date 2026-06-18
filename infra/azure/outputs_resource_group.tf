# Outputs for State Resource Group
output "resource_group_name_state" {
  description = "The name of the Resource Group where state resources are deployed."
  value       = azurerm_resource_group.state.name
}

output "resource_group_id_state" {
  description = "The ID of the Resource Group where state resources are deployed."
  value       = azurerm_resource_group.state.id
}



# Outputs for Demo Resource Group
output "resource_group_name_demo" {
  description = "The name of the Resource Group where demo resources are deployed."
  value       = azurerm_resource_group.demo.name
}

output "resource_group_id_demo" {
  description = "The ID of the Resource Group where demo resources are deployed."
  value       = azurerm_resource_group.demo.id
}