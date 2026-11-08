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

### 4. Adopt the existing resources into R2 state

No local Terraform command is required. On the next push to `main`, the GitHub
Actions workflow imports the already-created Pages project, domains, and DNS
records into the R2 backend before applying. Imports are skipped once each
resource is present in state.

## Local usage
For day-to-day site edits, commit and push; GitHub Actions handles the
infrastructure plan/apply. The optional `backend.hcl.example` is only for
manual local Terraform work.
