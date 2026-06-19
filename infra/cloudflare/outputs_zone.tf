output "zone_id" {
  description = "The ID of the Cloudflare zone to manage."
  value       = cloudflare_zone.demo.id
}

output "zone_name" {
  description = "The name of the Cloudflare zone."
  value       = cloudflare_zone.demo.name
}

output "zone_status" {
  description = "The status of the Cloudflare zone."
  value       = cloudflare_zone.demo.status
}

output "zone_created_on" {
  description = "The creation date of the Cloudflare zone."
  value       = cloudflare_zone.demo.created_on
}

output "zone_name_servers" {
  description = "The name servers of the Cloudflare zone."
  value       = cloudflare_zone.demo.name_servers
}

output "zone_original_dnshost" {
  description = "The original DNS host of the Cloudflare zone."
  value       = cloudflare_zone.demo.original_dnshost
}

output "zone_original_name_servers" {
  description = "The original name servers of the Cloudflare zone."
  value       = cloudflare_zone.demo.original_name_servers
}

output "zone_original_registrar" {
  description = "The original registrar of the Cloudflare zone."
  value       = cloudflare_zone.demo.original_registrar
}

output "zone_paused" {
  description = "The paused status of the Cloudflare zone."
  value       = cloudflare_zone.demo.paused
}

output "zone_type" {
  description = "The type of the Cloudflare zone."
  value       = cloudflare_zone.demo.type
}