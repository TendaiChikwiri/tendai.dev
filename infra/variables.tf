variable "cloudflare_api_token" {
  description = "Cloudflare API token (Account > Cloudflare Pages Edit, Zone > DNS Edit)."
  type        = string
  sensitive   = true
}

variable "cloudflare_account_id" {
  description = "Cloudflare account ID (shown on the Pages dashboard / API tokens page)."
  type        = string
}

variable "domain" {
  description = "Root domain to serve the site from."
  type        = string
  default     = "tendai.dev"
}

variable "github_owner" {
  description = "GitHub user or org that owns the repo."
  type        = string
  default     = "TendaiChikwiri"
}

variable "github_repo_name" {
  description = "GitHub repository name for the site source."
  type        = string
  default     = "tendai.dev"
}
