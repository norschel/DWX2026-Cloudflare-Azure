output "zero_trust_access_application_id" {
  description = "The ID of the Zero Trust Access Application"
  value       = cloudflare_zero_trust_access_application.rbi.id
}

output "zero_trust_access_application_name" {
  description = "The name of the Zero Trust Access Application"
  value       = cloudflare_zero_trust_access_application.rbi.name
}