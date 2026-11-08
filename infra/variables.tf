variable "cloudflare_api_token" {
  description = "Cloudflare API token with Pages Write and DNS Edit permissions."
  type        = string
  sensitive   = true
}

variable "cloudflare_account_id" {
  description = "Cloudflare account ID."
  type        = string
}

variable "zone_id" {
  description = "Cloudflare zone ID for the domain."
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
