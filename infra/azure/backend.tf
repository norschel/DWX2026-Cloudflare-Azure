terraform {
  backend "azurerm" {
    resource_group_name  = "rg-edge-before-azure-demo"
    storage_account_name = "sttfstateedgewedemo001"
    container_name       = "stctfstatedemo001"
    key                  = "azure.terraform.tfstate"
  }
}