resource "cloudflare_zone" "demo" {
  account = {
    id = data.cloudflare_account.demo.account_id
  }
  name = var.zone_name
  type = "full"
}

resource "cloudflare_dns_record" "txt" {
  zone_id = cloudflare_zone.demo.id
  name    = "asuid.app"
  type    = "TXT"
  comment = "TXT record for Azure Web App custom domain verification."
  content = "\"${data.azurerm_linux_web_app.demo.custom_domain_verification_id}\""
  proxied = false
  ttl     = 3600
}

resource "cloudflare_dns_record" "cname" {
  zone_id = cloudflare_zone.demo.id
  name    = "app"
  type    = "CNAME"
  comment = "CNAME record for Azure Web App custom domain verification."
  content = data.azurerm_linux_web_app.demo.default_hostname
  proxied = false
  ttl     = 3600
}

resource "cloudflare_dns_record" "demo" {
  zone_id = cloudflare_zone.demo.id
  name    = "dwx2026"
  type    = "CNAME"
  comment = "CNAME record pointing to Azure Web App for DWX2026 demo."
  content = data.azurerm_linux_web_app.demo.default_hostname
  proxied = true
  ttl     = 1 # When a DNS record is marked as 'proxied' the TTL must be 1 as Cloudflare will control the TTL internally.
}

resource "azurerm_app_service_custom_hostname_binding" "demo" {
  depends_on = [
    cloudflare_dns_record.cname, # Ensure the CNAME record for the Azure Linux Web App is created before binding the custom hostname.
    cloudflare_dns_record.txt    # Ensure the TXT record for the Azure Linux Web App is created before binding the custom hostname.
  ]
  hostname            = "app.${var.zone_name}"
  app_service_name    = data.azurerm_linux_web_app.demo.name
  resource_group_name = data.azurerm_linux_web_app.demo.resource_group_name
}

resource "azurerm_app_service_managed_certificate" "demo" {
  custom_hostname_binding_id = azurerm_app_service_custom_hostname_binding.demo.id
}

resource "azurerm_app_service_certificate_binding" "demo" {
  hostname_binding_id = azurerm_app_service_custom_hostname_binding.demo.id
  certificate_id      = azurerm_app_service_managed_certificate.demo.id
  ssl_state           = "SniEnabled"
}

resource "cloudflare_ruleset" "demo" {
  zone_id     = cloudflare_zone.demo.id
  name        = "rset-dwx2026-azure-webapp"
  description = "Firewall ruleset for DWX2026 demo to block malicious traffic and manage caching."
  kind        = "zone"
  phase       = "http_request_firewall_custom"

  rules = [
    {
      description = "Block 'demo-scanner' user-agent"
      action      = "block"
      expression  = "(http.user_agent contains \"demo-scanner\")"
      enabled     = true
    },
    {
      description = "Block AI bots user-agent"
      action      = "block"
      expression  = "(http.request.uri.path ne \"/robots.txt\" and ((http.user_agent contains \"GPTBot\") or (http.user_agent contains \"PerplexityBot\")))"
      enabled     = true
    },
    {
      description = "Block Scrappers user-agent"
      action      = "managed_challenge"
      expression  = "(http.user_agent contains \"curl\") or (http.user_agent contains \"python-requests\")"
      enabled     = true
    }

    # {
    #   action      = "block"
    #   expression  = "http.request.headers[\"x-demo-traffic\"][0] eq \"suspicious\""
    #   description = "Demo 1: block suspicious header traffic"
    #   enabled     = var.enable_demo1_header_block_rule
    # },



  ]
}

# resource "cloudflare_ruleset" "demo_cache" {
#   zone_id = var.cloudflare_zone_id
#   name    = "edge-before-azure-cache"
#   kind    = "zone"
#   phase   = "http_request_cache_settings"

#   rules = [
#     {
#       action      = "set_cache_settings"
#       expression  = "http.request.uri.path eq \"/api/products\""
#       description = "Demo 3: cache products endpoint"
#       enabled     = var.enable_demo3_cache_rule
#       action_parameters = {
#         cache = true
#         edge_ttl = {
#           mode    = "override_origin"
#           default = 60
#         }
#         browser_ttl = {
#           mode    = "override_origin"
#           default = 60
#         }
#       }
#     }
#   ]
# }
