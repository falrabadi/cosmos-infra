# cosmos-infra

Infrastructure-as-Code for the Cosmos project. Provisions and configures the
environment that `cosmos-api` (and later `cosmos-ui`) deploy into.

## What lives here

| Path | Purpose |
|---|---|
| `terraform/` | Provisions the Hetzner VPS, firewall, and SSH key |
| `cloud-init/` | Installs k3s (lightweight Kubernetes) on the server at first boot |
| `k8s/base/` | Shared Kubernetes manifests for all environments |
| `k8s/overlays/staging/` | Staging-specific patches (Kustomize) |
| `k8s/overlays/production/` | Production-specific patches (Kustomize) |
| `.github/workflows/` | `terraform plan` on PRs, `terraform apply` on manual dispatch |

## Boundary with cosmos-api

`cosmos-api` builds and pushes container images to `ghcr.io`. This repo
references those images in its k8s manifests and deploys them. The only contract
between the two repos is the image name + tag — no app code lives here, no infra
code lives there.

## The stack

```
Terraform → Hetzner VPS → cloud-init installs k3s
GitHub Actions → ghcr.io images → Kustomize manifests → k3s cluster
```

## Security — read before first commit

- **Never commit** `*.tfstate`, `*.tfvars`, or any kubeconfig. They are gitignored.
- `terraform.tfvars.example` is the safe template — copy it to `terraform.tfvars`
  (gitignored) and fill in real values locally.
- CI gets its secrets from GitHub Actions secrets (`HCLOUD_TOKEN`,
  `SSH_PUBLIC_KEY`, `ALLOWED_SSH_IP`), never from committed files.
- Remote Terraform state should live in a private S3-compatible bucket
  (e.g. Cloudflare R2), configured in `terraform/versions.tf`.

## Local usage

```bash
cd terraform
cp terraform.tfvars.example terraform.tfvars   # then fill in real values
terraform init
terraform plan
terraform apply
```
