# Terraform State Management and Azure Resource Provisioning
resource "azurerm_resource_group" "state" {
  name     = var.resource_group_name_state
  location = var.location
}

resource "azurerm_storage_account" "state" {
  name                            = "sttfstateedgewedemo001"
  location                        = var.location
  resource_group_name             = azurerm_resource_group.state.name
  account_tier                    = "Standard"
  account_replication_type        = "LRS"
  allow_nested_items_to_be_public = false
}

resource "azurerm_storage_container" "state" {
  name                  = "stctfstatedemo001"
  storage_account_id    = azurerm_storage_account.state.id
  container_access_type = "private"
}



# Azure resources for the demo application 'Cloudflare - WebApp'
resource "azurerm_resource_group" "demo" {
  name     = var.resource_group_name_demo
  location = var.location
}

resource "azurerm_log_analytics_workspace" "demo" {
  name                = "log-edge-before-azure-demo"
  location            = var.location
  resource_group_name = azurerm_resource_group.demo.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

resource "azurerm_application_insights" "demo" {
  name                = "appi-edge-before-azure-demo"
  location            = var.location
  resource_group_name = azurerm_resource_group.demo.name
  workspace_id        = azurerm_log_analytics_workspace.demo.id
  application_type    = "web"
}

resource "azurerm_service_plan" "demo" {
  name                = "asp-edge-before-azure-demo"
  location            = var.location
  resource_group_name = azurerm_resource_group.demo.name
  os_type             = "Linux"
  sku_name            = "B1"
}

resource "azurerm_linux_web_app" "demo" {
  name                = var.linux_web_app_name
  location            = var.location
  resource_group_name = azurerm_resource_group.demo.name
  service_plan_id     = azurerm_service_plan.demo.id
  https_only          = true

  site_config {
    application_stack {
      dotnet_version = "10.0"
    }
  }

  app_settings = {
    ASPNETCORE_ENVIRONMENT                = "Production"
    APPLICATIONINSIGHTS_CONNECTION_STRING = azurerm_application_insights.demo.connection_string
    Demo__ProductsDelayMilliseconds       = tostring(500)
    WEBSITES_ENABLE_APP_SERVICE_STORAGE   = "false"
  }

  lifecycle {
    ignore_changes = [tags]
  }
}
