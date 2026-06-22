output "zero_trust_gateway_policy_id" {
  description = "The Cloudflare Zero Trust Gateway Policy ID."
  value       = cloudflare_zero_trust_gateway_policy.demo.id
}

output "zero_trust_gateway_policy_name" {
  description = "The Cloudflare Zero Trust Gateway Policy name."
  value       = cloudflare_zero_trust_gateway_policy.demo.name
}

output "zero_trust_gateway_policy_warning_status" {
  description = "The Cloudflare Zero Trust Gateway Policy warning status."
  value       = cloudflare_zero_trust_gateway_policy.demo.warning_status
}