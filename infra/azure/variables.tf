variable "resource_group_name" {
  type        = string
  description = "Azure resource group name"
  default     = "rg-edge-before-azure-demo"
}

variable "location" {
  type        = string
  description = "Azure region"
  default     = "westeurope"
}

variable "app_service_plan_name" {
  type        = string
  description = "App Service plan name"
  default     = "asp-edge-before-azure-demo"
}

variable "app_name" {
  type        = string
  description = "Linux Web App name"
  default     = "edge-before-azure-demo-app"
}

variable "log_analytics_workspace_name" {
  type        = string
  description = "Log Analytics workspace name"
  default     = "log-edge-before-azure-demo"
}

variable "application_insights_name" {
  type        = string
  description = "Application Insights name"
  default     = "appi-edge-before-azure-demo"
}

variable "sku_name" {
  type        = string
  description = "App Service plan SKU"
  default     = "B1"
}

variable "products_delay_milliseconds" {
  type        = number
  description = "Delay for /api/products endpoint"
  default     = 500
}
