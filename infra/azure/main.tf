resource "azurerm_resource_group" "demo" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_log_analytics_workspace" "demo" {
  name                = var.log_analytics_workspace_name
  location            = azurerm_resource_group.demo.location
  resource_group_name = azurerm_resource_group.demo.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

resource "azurerm_application_insights" "demo" {
  name                = var.application_insights_name
  location            = azurerm_resource_group.demo.location
  resource_group_name = azurerm_resource_group.demo.name
  workspace_id        = azurerm_log_analytics_workspace.demo.id
  application_type    = "web"
}

resource "azurerm_service_plan" "demo" {
  name                = var.app_service_plan_name
  location            = azurerm_resource_group.demo.location
  resource_group_name = azurerm_resource_group.demo.name
  os_type             = "Linux"
  sku_name            = var.sku_name
}

resource "azurerm_linux_web_app" "demo" {
  name                = var.app_name
  location            = azurerm_resource_group.demo.location
  resource_group_name = azurerm_resource_group.demo.name
  service_plan_id     = azurerm_service_plan.demo.id
  https_only          = true

  site_config {
    application_stack {
      dotnet_version = "10.0"
    }
  }

  app_settings = {
    ASPNETCORE_ENVIRONMENT                  = "Production"
    APPLICATIONINSIGHTS_CONNECTION_STRING   = azurerm_application_insights.demo.connection_string
    Demo__ProductsDelayMilliseconds         = tostring(var.products_delay_milliseconds)
    WEBSITES_ENABLE_APP_SERVICE_STORAGE     = "false"
  }
}
