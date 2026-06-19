output "dns_record_name" {
  description = "The DNS record name created in Cloudflare."
  value       = cloudflare_dns_record.demo.name
}

output "dns_record_id" {
  description = "The DNS record ID created in Cloudflare."
  value       = cloudflare_dns_record.demo.id
}

output "dns_record_settings" {
  description = "The DNS record settings created in Cloudflare."
  value       = cloudflare_dns_record.demo.settings
}