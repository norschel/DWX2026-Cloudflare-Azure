output "tiered_cache_id" {
  description = "The ID of the Cloudflare tiered cache setting."
  value       = cloudflare_tiered_cache.demo.id
}

output "tiered_cache_editable" {
  description = "Indicates if the Cloudflare tiered cache setting is editable."
  value       = cloudflare_tiered_cache.demo.editable
}

output "tiered_cache_value" {
  description = "The value of the Cloudflare tiered cache setting."
  value       = cloudflare_tiered_cache.demo.value
}