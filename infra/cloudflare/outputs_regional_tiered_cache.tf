output "regional_tiered_cache_id" {
  description = "The ID of the Cloudflare regional tiered cache setting."
  value       = cloudflare_regional_tiered_cache.demo.id
}

output "regional_tiered_cache_editable" {
  description = "Indicates if the Cloudflare regional tiered cache setting is editable."
  value       = cloudflare_regional_tiered_cache.demo.editable
}

output "regional_tiered_cache_value" {
  description = "The value of the Cloudflare regional tiered cache setting."
  value       = cloudflare_regional_tiered_cache.demo.value
}