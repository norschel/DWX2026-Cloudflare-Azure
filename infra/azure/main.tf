resource "azurerm_resource_group" "demo" {
  name     = "rg-edge-before-azure-demo"
  location = var.location
}

resource "azurerm_storage_account" "demo" {
  name                            = "sttfstateedgewedemo001"
  location                        = var.location
  resource_group_name             = azurerm_resource_group.demo.name
  account_tier                    = "Standard"
  account_replication_type        = "LRS"
  allow_nested_items_to_be_public = false
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
  name                = "edge-before-azure-demo-app"
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
