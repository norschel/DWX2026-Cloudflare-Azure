variable "cloudflare_api_token" {
  type        = string
  description = "Cloudflare API token"
  sensitive   = true
}

variable "cloudflare_zone_id" {
  type        = string
  description = "Cloudflare zone id"
}

variable "cloudflare_account_id" {
  type        = string
  description = "Cloudflare account id"
}

variable "demo_hostname" {
  type        = string
  description = "Demo FQDN managed by Cloudflare"
}

variable "azure_origin_hostname" {
  type        = string
  description = "Azure origin hostname"
}

variable "enable_demo1_header_block_rule" {
  type        = bool
  description = "Enable blocking of suspicious demo header"
  default     = false
}

variable "enable_demo1_user_agent_block_rule" {
  type        = bool
  description = "Enable blocking of demo-scanner user-agent"
  default     = false
}

variable "enable_demo2_ai_block_rule" {
  type        = bool
  description = "Enable blocking of AI crawler user-agents"
  default     = false
}

variable "enable_demo2_scraper_challenge_rule" {
  type        = bool
  description = "Enable managed challenge for scraper user-agents"
  default     = false
}

variable "enable_demo3_cache_rule" {
  type        = bool
  description = "Enable caching for /api/products"
  default     = false
}
