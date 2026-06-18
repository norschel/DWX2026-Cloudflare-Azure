import {
  # azurerm_storage_account (TF State)
  to = azurerm_storage_account.state
  id = "/subscriptions/${var.subscription_id}/resourceGroups/${azurerm_resource_group.state.name}/providers/Microsoft.Storage/storageAccounts/${var.storage_account_name}"
}

import {
  # azurerm_storage_container (TF State)
  to = azurerm_storage_container.state
  id = "/subscriptions/${var.subscription_id}/resourceGroups/${azurerm_resource_group.state.name}/providers/Microsoft.Storage/storageAccounts/${var.storage_account_name}/blobServices/default/containers/${var.storage_container_name}"
}