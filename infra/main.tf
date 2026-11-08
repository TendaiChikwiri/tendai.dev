terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 4.0"
    }
  }
}

provider "cloudflare" {
  api_token = var.cloudflare_api_token
}

data "cloudflare_zone" "site" {
  name = var.domain
}

# Cloudflare Pages project, wired to the GitHub repo for CI builds.
resource "cloudflare_pages_project" "site" {
  account_id        = var.cloudflare_account_id
  name              = "tendai-dev"
  production_branch = "main"

  source {
    type = "github"
    config {
      owner             = var.github_owner
      repo_name         = var.github_repo_name
      production_branch = "main"
    }
  }

  # Static site: no build command, serve the repo root.
  build_config {
    build_command = ""
    destination_dir = ""
  }
}

# Attach the custom domain to the Pages project.
resource "cloudflare_pages_domain" "apex" {
  account_id   = var.cloudflare_account_id
  project_name = cloudflare_pages_project.site.name
  domain       = var.domain
}

resource "cloudflare_pages_domain" "www" {
  account_id   = var.cloudflare_account_id
  project_name = cloudflare_pages_project.site.name
  domain       = "www.${var.domain}"
}

# DNS records pointing at the Pages project (CNAME flattening at apex).
resource "cloudflare_record" "apex" {
  zone_id = data.cloudflare_zone.site.id
  name    = "@"
  type    = "CNAME"
  content = cloudflare_pages_project.site.subdomain
  proxied = true
}

resource "cloudflare_record" "www" {
  zone_id = data.cloudflare_zone.site.id
  name    = "www"
  type    = "CNAME"
  content = cloudflare_pages_project.site.subdomain
  proxied = true
}
