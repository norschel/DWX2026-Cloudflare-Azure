data "cloudflare_workers_custom_domains" "demo" {
  account_id = var.cloudflare_account_id
  #project_name = "ch-xebia.cftenant.com"
  #domain_name  = "ch-xebia.cftenant.com"
}

data "azurerm_linux_web_app" "demo" {
  name                = var.linux_web_app_name
  resource_group_name = var.resource_group_name_demo
}

