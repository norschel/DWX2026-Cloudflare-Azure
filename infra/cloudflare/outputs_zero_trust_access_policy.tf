output "zero_trust_access_policy_id" {
  description = "The ID of the Zero Trust Access Policy"
  value       = cloudflare_zero_trust_access_policy.rbi.id
}

output "zero_trust_access_policy_name" {
  description = "The name of the Zero Trust Access Policy"
  value       = cloudflare_zero_trust_access_policy.rbi.name
}