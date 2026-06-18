output "storage_account_name" {
  description = "The name of the Storage Account used for Terraform state storage."
  value       = azurerm_storage_account.demo.name
}

output "storage_account_id" {
  description = "The ID of the Storage Account used for Terraform state storage."
  value       = azurerm_storage_account.demo.id
}