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
  default     = "12751c97db11e5829819ecac166c2234" # 'Stefan Rapp's Account'
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