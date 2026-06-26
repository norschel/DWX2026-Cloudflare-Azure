terraform {
  backend "azurerm" {
    # Variables cannot be used directly in the backend configuration (not supported), so we hardcode the values here. 
    resource_group_name  = "rg-edge-before-azure-state"
    storage_account_name = "sttfstateedgewedemo001"
    container_name       = "stctfstatedemo001"
    key                  = "azure.terraform.tfstate"
  }
}
