output "ruleset_name" {
  description = "The name of the Cloudflare ruleset created."
  value       = cloudflare_ruleset.demo.name
}

output "ruleset_kind" {
  description = "The kind of the Cloudflare ruleset created."
  value       = cloudflare_ruleset.demo.kind
}

output "ruleset_phase" {
  description = "The phase of the Cloudflare ruleset created."
  value       = cloudflare_ruleset.demo.phase
}

output "ruleset_rules" {
  description = "The rules of the Cloudflare ruleset created."
  value       = cloudflare_ruleset.demo.rules
}

output "ruleset_version" {
  description = "The version of the Cloudflare ruleset created."
  value       = cloudflare_ruleset.demo.version
}