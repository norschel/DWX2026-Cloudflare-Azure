output "demo_hostname" {
  value = var.demo_hostname
}

output "demo_url" {
  value = "https://${var.demo_hostname}"
}

output "azure_origin_hostname" {
  value = var.azure_origin_hostname
}
