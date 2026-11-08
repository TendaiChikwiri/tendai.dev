terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 5.0"
    }
  }
}

provider "cloudflare" {
  api_token = var.cloudflare_api_token
}

# Cloudflare Pages project, wired to the GitHub repo for CI builds.
resource "cloudflare_pages_project" "site" {
  account_id        = var.cloudflare_account_id
  name              = "tendai-dev"
  production_branch = "main"

  source = {
    type = "github"
    config = {
      owner             = var.github_owner
      repo_name         = var.github_repo_name
      production_branch = "main"
    }
  }

  # Static site: no build step, serve the public/ directory.
  build_config = {
    build_command   = "exit 0"
    destination_dir = "public"
  }
}

# Attach the custom domain to the Pages project.
resource "cloudflare_pages_domain" "apex" {
  account_id   = var.cloudflare_account_id
  project_name = cloudflare_pages_project.site.name
  name         = var.domain
}

resource "cloudflare_pages_domain" "www" {
  account_id   = var.cloudflare_account_id
  project_name = cloudflare_pages_project.site.name
  name         = "www.${var.domain}"
}

# DNS records pointing at the Pages project (CNAME flattening at apex).
resource "cloudflare_dns_record" "apex" {
  zone_id = var.zone_id
  name    = var.domain
  type    = "CNAME"
  content = cloudflare_pages_project.site.subdomain
  proxied = true
  ttl     = 1
}

resource "cloudflare_dns_record" "www" {
  zone_id = var.zone_id
  name    = "www.${var.domain}"
  type    = "CNAME"
  content = cloudflare_pages_project.site.subdomain
  proxied = true
  ttl     = 1
}
