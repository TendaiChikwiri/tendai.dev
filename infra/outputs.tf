output "pages_subdomain" {
  description = "Cloudflare-provided *.pages.dev URL."
  value       = cloudflare_pages_project.site.subdomain
}

output "site_url" {
  description = "Primary site URL."
  value       = "https://${var.domain}"
}
