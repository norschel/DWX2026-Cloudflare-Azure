output "zone_setting_image_resizing_id" {
  description = "The ID of the Cloudflare zone settings."
  value       = cloudflare_zone_setting.image_resizing.id
}