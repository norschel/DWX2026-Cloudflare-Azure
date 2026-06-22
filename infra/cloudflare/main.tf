resource "cloudflare_zone" "demo" {
  account = {
    id = data.cloudflare_account.demo.account_id
  }
  name = var.zone_name
  type = "full"

  lifecycle {
    prevent_destroy = true
  }
}

resource "cloudflare_dns_record" "txt" {
  zone_id = cloudflare_zone.demo.id
  name    = "asuid.${var.domain_service_prefix_name}"
  type    = "TXT"
  comment = "TXT record for Azure Web App custom domain verification (without proxy)."
  content = "\"${data.azurerm_linux_web_app.demo.custom_domain_verification_id}\""
  proxied = false
  ttl     = 3600
}

resource "cloudflare_dns_record" "cname" {
  zone_id = cloudflare_zone.demo.id
  name    = var.domain_service_prefix_name
  type    = "CNAME"
  comment = "CNAME record for Azure Web App custom domain verification (without proxy)."
  content = data.azurerm_linux_web_app.demo.default_hostname
  proxied = true
  ttl     = 1
}

resource "azurerm_app_service_custom_hostname_binding" "demo" {
  depends_on = [
    cloudflare_dns_record.cname, # Ensure the CNAME record for the Azure Linux Web App is created before binding the custom hostname.
    cloudflare_dns_record.txt    # Ensure the TXT record for the Azure Linux Web App is created before binding the custom hostname.
  ]
  hostname            = "${var.domain_service_prefix_name}.${var.zone_name}"
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

resource "cloudflare_ruleset" "block" {
  zone_id     = cloudflare_zone.demo.id
  name        = "rset-dwx2026-azure-webapp-block"
  description = "Firewall ruleset for DWX2026 demo to block malicious traffic and manage caching."
  kind        = "zone"
  phase       = "http_request_firewall_custom"

  rules = [
    {
      action      = "block"
      description = "Block 'demo-scanner' user-agent"
      expression  = "(http.user_agent contains \"demo-scanner\")"
      enabled     = true
      action_parameters = {
        response = {
          content      = "You have been blocked from accessing this resource."
          content_type = "application/json"
          status_code  = 403
        }
      }
    },
    {
      action      = "block"
      description = "Block AI bots user-agent"
      expression  = "(http.request.uri.path ne \"/robots.txt\" and ((http.user_agent contains \"GPTBot\") or (http.user_agent contains \"PerplexityBot\")))"
      enabled     = true
      action_parameters = {
        response = {
          content      = "{\"message\":\"Please contact the site owner for access.\"}"
          content_type = "application/json"
          status_code  = 403
        }
      }
    },
    {
      action      = "block"
      description = "Block Scrappers user-agent"
      expression  = "(http.user_agent contains \"curl\") or (http.user_agent contains \"python-requests\")"
      enabled     = true
    },
  ]
}

resource "cloudflare_ruleset" "ratelimit" {
  zone_id     = cloudflare_zone.demo.id
  name        = "rset-dwx2026-azure-webapp-ratelimit"
  description = "Firewall ruleset for DWX2026 demo for rate limiting."
  kind        = "zone"
  phase       = "http_ratelimit"

  rules = [
    {
      action      = "block"
      description = "Weather API free rate limit."
      expression  = "(http.request.uri.path wildcard r\"/api/weather\")"
      enabled     = true
      ratelimit = {
        characteristics = [
          "cf.unique_visitor_id",
          "cf.colo.id",
        ]
        action              = "challenge"
        period              = 60
        requests_per_period = 100
        mitigation_timeout  = 60,
      }
      action_parameters = {
        response = {
          content      = "You have been rate limited. Please try again later."
          content_type = "text/plain"
          status_code  = 429
        }
        timeout = 60
      }
    },
  ]
}

resource "cloudflare_ruleset" "cache" {
  zone_id = cloudflare_zone.demo.id
  name    = "rset-dwx2026-azure-webapp-cache"
  kind    = "zone"
  phase   = "http_request_cache_settings"

  rules = [
    {
      description = "Cache Everything (Template)"
      action      = "set_cache_settings"
      expression  = "(http.request.uri.path wildcard r\"/api/weather\")"
      enabled     = true


      action_parameters = {
        cache = true
        edge_ttl = {
          mode    = "override_origin"
          default = 10
          status_code_ttl = [
            {
              value       = 10
              status_code = 200 # OK
            },
            {
              value       = 300 # 5 minutes
              status_code = 400 # Bad Request
            }
          ]
        }
        browser_ttl = {
          mode    = "override_origin"
          default = 10
        }
      }
    },
    {
      description = "Cache 'Products' Website"
      action      = "set_cache_settings"
      expression  = "(http.request.uri.path wildcard r\"/api/products\")"
      enabled     = true

      action_parameters = {
        cache = true
        edge_ttl = {
          mode    = "override_origin"
          default = 60
        }
        browser_ttl = {
          mode    = "override_origin"
          default = 60 # 1 minute browser cache TTL
        }
      }
    }
  ]
}

resource "cloudflare_tiered_cache" "demo" {
  zone_id = cloudflare_zone.demo.id
  value   = "on"
}

resource "cloudflare_regional_tiered_cache" "demo" {
  zone_id = cloudflare_zone.demo.id
  value   = "off"
}

# resource "cloudflare_zero_trust_gateway_settings" "demo" {
#   account_id = data.cloudflare_account.demo.account_id

#   settings = {
#     tls_decrypt = {
#       enabled = true
#     }
#   }
# }

resource "cloudflare_zero_trust_access_policy" "demo" {
  account_id = data.cloudflare_account.demo.account_id
  name       = "Allow Clientless Browser Access"
  decision   = "allow"

  include = [{
    everyone = {}
  }]
}

resource "cloudflare_zero_trust_gateway_policy" "demo" {
  account_id  = data.cloudflare_account.demo.account_id
  name        = "Isolate Health API"
  description = "Policy to isolate the '/api/health' endpoint from all other traffic for security and performance reasons."
  precedence  = 1000
  enabled     = true
  action      = "isolate"
  filters     = ["http"]
  traffic     = "http.request.uri == \"https://dwxapp.cfmisterazure.com/api/health\""

  rule_settings = {
    biso_admin_controls = {
      version  = "v2"
      download = "remote_only"
      upload   = "disabled"
      copy     = "remote_only"
      paste    = "remote_only"
    }
  }
}