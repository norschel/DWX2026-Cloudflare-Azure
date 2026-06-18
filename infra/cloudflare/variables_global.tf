# Global variables for Azure Configurations
variable "tenant_id" {
  description = "The Azure tenant ID to use for authentication."
  type        = string
}

variable "subscription_id" {
  description = "The Azure subscription ID to use for authentication."
  type        = string
}



# Global variables for Cloudflare Configurations
variable "cloudflare_account_id" {
  description = "The Cloudflare account ID for authentication."
  type        = string
  default     = "f9405b66f77a3b72ba22678e8a4c9e84" # 'NFR - EMEA - CH - Xebia'
}

variable "cloudflare_zone_name" {
  description = "The Cloudflare zone name for the domain being managed."
  type        = string
  default     = "ch-xebia.cftenant.com"
}

variable "cloudflare_api_token" {
  description = "The Cloudflare API token for authentication."
  type        = string
  sensitive   = true
}