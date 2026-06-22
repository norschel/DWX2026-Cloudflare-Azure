# Block
output "ruleset_name_block" {
  description = "The name of the Cloudflare ruleset created."
  value       = try(cloudflare_ruleset.block.name, null)
}

output "ruleset_kind_block" {
  description = "The kind of the Cloudflare ruleset created."
  value       = try(cloudflare_ruleset.block.kind, null)
}

output "ruleset_phase_block" {
  description = "The phase of the Cloudflare ruleset created."
  value       = try(cloudflare_ruleset.block.phase, null)
}

output "ruleset_rules_block" {
  description = "The rules of the Cloudflare ruleset created."
  value       = try(cloudflare_ruleset.block.rules, null)
}

output "ruleset_version_block" {
  description = "The version of the Cloudflare ruleset created."
  value       = try(cloudflare_ruleset.block.version, null)
}



# Rate Limit
output "ruleset_name_ratelimit" {
  description = "The name of the Cloudflare ruleset created."
  value       = try(cloudflare_ruleset.ratelimit.name, null)
}

output "ruleset_kind_ratelimit" {
  description = "The kind of the Cloudflare ruleset created."
  value       = try(cloudflare_ruleset.ratelimit.kind, null)
}

output "ruleset_phase_ratelimit" {
  description = "The phase of the Cloudflare ruleset created."
  value       = try(cloudflare_ruleset.ratelimit.phase, null)
}

output "ruleset_rules_ratelimit" {
  description = "The rules of the Cloudflare ruleset created."
  value       = try(cloudflare_ruleset.ratelimit.rules, null)
}

output "ruleset_version_ratelimit" {
  description = "The version of the Cloudflare ruleset created."
  value       = try(cloudflare_ruleset.ratelimit.version, null)
}



# Cache Settings
output "ruleset_name_cache" {
  description = "The name of the Cloudflare ruleset created."
  value       = try(cloudflare_ruleset.cache.name, null)
}

output "ruleset_kind_cache" {
  description = "The kind of the Cloudflare ruleset created."
  value       = try(cloudflare_ruleset.cache.kind, null)
}

output "ruleset_phase_cache" {
  description = "The phase of the Cloudflare ruleset created."
  value       = try(cloudflare_ruleset.cache.phase, null)
}

output "ruleset_rules_cache" {
  description = "The rules of the Cloudflare ruleset created."
  value       = try(cloudflare_ruleset.cache.rules, null)
}

output "ruleset_version_cache" {
  description = "The version of the Cloudflare ruleset created."
  value       = try(cloudflare_ruleset.cache.version, null)
}