data "cloudflare_account" "demo" {
  account_id = var.cloudflare_account_id
}

data "azurerm_linux_web_app" "demo" {
  name                = var.linux_web_app_name
  resource_group_name = var.resource_group_name_demo
}

