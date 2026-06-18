# output "demo_hostname" {
#   value = var.demo_hostname
# }

# output "demo_url" {
#   value = "https://${var.demo_hostname}"
# }

# output "azure_origin_hostname" {
#   value = var.azure_origin_hostname
# }

output "test" {
  description = "The name of the Cloudflare DNS record pointing to the Azure origin."
  value       = data.cloudflare_workers_custom_domains.demo.result
}
