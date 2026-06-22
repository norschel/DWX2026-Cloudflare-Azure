output "zone_cache_reserve_id" {
  description = "The ID of the Cloudflare zone cache reserve setting."
  value       = cloudflare_zone_cache_reserve.demo.id
}

output "zone_cache_reserve_editable" {
  description = "Indicates if the Cloudflare zone cache reserve setting is editable."
  value       = cloudflare_zone_cache_reserve.demo.editable
}

output "zone_cache_reserve_value" {
  description = "The value of the Cloudflare zone cache reserve setting."
  value       = cloudflare_zone_cache_reserve.demo.value
}