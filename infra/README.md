# Infrastructure

Terraform for the Cloudflare Pages site. Remote state lives in Cloudflare R2
(S3-compatible backend); plan/apply run in GitHub Actions.

## One-time setup

### 1. Create an R2 bucket
Cloudflare dashboard → **R2** → **Create bucket** → name it `tendai-dev-terraform-state`.

### 2. Create an R2 API token
Cloudflare dashboard → **R2** → **Manage R2 API Tokens** → **Create API token**.
Grant **Object Read & Write** on the bucket above. Save the Access Key ID and
Secret Access Key (shown once).

### 3. Add GitHub secrets
In the repo → **Settings → Secrets and variables → Actions**, add:

| Secret | Value |
| --- | --- |
| `CLOUDFLARE_API_TOKEN` | your Cloudflare API token |
| `CLOUDFLARE_ACCOUNT_ID` | `df9eeae7ad10710d3908f1895e0d1ca2` |
| `CLOUDFLARE_ZONE_ID` | `1ebb601bf40a5196024910af21b63659` |
| `R2_ACCESS_KEY_ID` | R2 access key ID |
| `R2_SECRET_ACCESS_KEY` | R2 secret access key |
| `R2_BUCKET` | `tendai-dev-terraform-state` |

### 4. Migrate local state into R2 (once)
```bash
cd infra
cp backend.hcl.example backend.hcl   # fill in your account ID
export AWS_ACCESS_KEY_ID="<R2 access key id>"
export AWS_SECRET_ACCESS_KEY="<R2 secret access key>"
terraform init -backend-config=backend.hcl -migrate-state
```

## Local usage
After migration, use the same `-backend-config=backend.hcl` for any local
`init`/`plan`/`apply`. For day-to-day site edits, just commit and push; the
workflow handles the rest.
