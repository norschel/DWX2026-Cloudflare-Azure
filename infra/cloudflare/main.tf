resource "cloudflare_dns_record" "demo_origin" {
  zone_id = var.cloudflare_zone_id
  name    = var.demo_hostname
  type    = "CNAME"
  content = var.azure_origin_hostname
  proxied = true
  ttl     = 1
}

resource "cloudflare_ruleset" "demo_firewall" {
  zone_id = var.cloudflare_zone_id
  name    = "edge-before-azure-firewall"
  kind    = "zone"
  phase   = "http_request_firewall_custom"

  rules = [
    {
      action      = "block"
      expression  = "http.request.headers[\"x-demo-traffic\"][0] eq \"suspicious\""
      description = "Demo 1: block suspicious header traffic"
      enabled     = var.enable_demo1_header_block_rule
    },
    {
      action      = "block"
      expression  = "contains(lower(http.user_agent), \"demo-scanner\")"
      description = "Demo 1: block demo scanner user-agent"
      enabled     = var.enable_demo1_user_agent_block_rule
    },
    {
      action      = "block"
      expression  = "contains(http.user_agent, \"GPTBot\") or contains(http.user_agent, \"ClaudeBot\") or contains(http.user_agent, \"PerplexityBot\")"
      description = "Demo 2: block AI crawlers"
      enabled     = var.enable_demo2_ai_block_rule
    },
    {
      action      = "managed_challenge"
      expression  = "contains(lower(http.user_agent), \"curl\") or contains(lower(http.user_agent), \"python-requests\")"
      description = "Demo 2: challenge scraper traffic"
      enabled     = var.enable_demo2_scraper_challenge_rule
    }
  ]
}

resource "cloudflare_ruleset" "demo_cache" {
  zone_id = var.cloudflare_zone_id
  name    = "edge-before-azure-cache"
  kind    = "zone"
  phase   = "http_request_cache_settings"

  rules = [
    {
      action      = "set_cache_settings"
      expression  = "http.request.uri.path eq \"/api/products\""
      description = "Demo 3: cache products endpoint"
      enabled     = var.enable_demo3_cache_rule
      action_parameters = {
        cache = true
        edge_ttl = {
          mode    = "override_origin"
          default = 60
        }
        browser_ttl = {
          mode    = "override_origin"
          default = 60
        }
      }
    }
  ]
}
