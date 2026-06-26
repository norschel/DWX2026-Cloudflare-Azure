output "account_id" {
  description = "The Cloudflare account ID."
  value       = data.cloudflare_account.demo.account_id
}

output "account_name" {
  description = "The Cloudflare account name."
  value       = data.cloudflare_account.demo.name
}

output "account_type" {
  description = "The Cloudflare account type."
  value       = data.cloudflare_account.demo.type
}

output "account_managed_by" {
  description = "The Cloudflare account managed by."
  value       = data.cloudflare_account.demo.managed_by
}