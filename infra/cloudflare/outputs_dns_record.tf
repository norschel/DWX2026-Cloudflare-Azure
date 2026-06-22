# DNS TXT Record (Hostname Binding)
output "dns_record_txt_name" {
  description = "The DNS TXT record name for hostname binding created in Cloudflare."
  value       = cloudflare_dns_record.txt.name
}

output "dns_record_txt_id" {
  description = "The DNS TXT record ID for hostname binding created in Cloudflare."
  value       = cloudflare_dns_record.txt.id
}

output "dns_record_txt_settings" {
  description = "The DNS TXT record settings for hostname binding created in Cloudflare."
  value       = cloudflare_dns_record.txt.settings
}



# DNS CNAME Record (Hostname Binding)
output "dns_record_cname_name" {
  description = "The DNS CNAME record name for hostname binding created in Cloudflare."
  value       = cloudflare_dns_record.cname.name
}

output "dns_record_cname_id" {
  description = "The DNS CNAME record ID for hostname binding created in Cloudflare."
  value       = cloudflare_dns_record.cname.id
}

output "dns_record_cname_settings" {
  description = "The DNS CNAME record settings for hostname binding created in Cloudflare."
  value       = cloudflare_dns_record.cname.settings
}