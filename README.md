# cosmos-infra

Infrastructure-as-Code for the Cosmos project. Provisions and configures the
environment that `cosmos-api` (and later `cosmos-ui`) deploy into.

## What lives here

| Path | Purpose |
|---|---|
| `terraform/` | Provisions an Azure resource group + AKS (managed Kubernetes) cluster |
| `k8s/base/` | Shared Kubernetes manifests for all environments |
| `k8s/overlays/staging/` | Staging-specific patches (Kustomize) |
| `k8s/overlays/production/` | Production-specific patches (Kustomize) |
| `.github/workflows/` | `terraform plan` on PRs, `terraform apply` on manual dispatch |

## Boundary with cosmos-api

`cosmos-api` builds and pushes container images to `ghcr.io`. This repo
references those images in its k8s manifests and deploys them to AKS. The only
contract between the two repos is the image name + tag — no app code lives here,
no infra code lives there.

## The stack

```
Terraform → Azure Resource Group → AKS cluster (Free control plane, 1x B2als_v2 node)
GitHub Actions → ghcr.io images → Kustomize manifests → AKS
```

## Cost

- **Control plane:** Free tier ($0).
- **Node:** one `Standard_B2als_v2` (2 vCPU / 4 GiB), billed per hour it runs.
- Leave it always-on ≈ ~$32/mo. Use `terraform destroy` or `az aks stop`
  between sessions and you pay only for active hours (a few $/mo).
- New accounts get a $200 / 30-day credit — month one is effectively free.

## Prerequisites

- [Azure CLI](https://learn.microsoft.com/cli/azure/install-azure-cli) (`az`)
- An Azure subscription (`az login`, then `az account show --query id -o tsv`)
- Terraform >= 1.6

## Security — read before first commit

- **Never commit** `*.tfstate` or `*.tfvars`. They are gitignored.
- `terraform.tfvars.example` is the safe template — copy it to `terraform.tfvars`
  (gitignored) and fill in your subscription ID.
- Local auth is via `az login` (no client secret stored).
- CI auth is via Azure OIDC federation — repo secrets `AZURE_CLIENT_ID`,
  `AZURE_TENANT_ID`, `AZURE_SUBSCRIPTION_ID`, never a committed secret.
- Remote Terraform state should live in an Azure Storage account, configured in
  `terraform/versions.tf`.

## Local usage

```bash
az login                                         # authenticate
cd terraform
cp terraform.tfvars.example terraform.tfvars     # then fill in subscription_id
terraform init
terraform plan
terraform apply

# Point kubectl at the new cluster (the apply output prints this command):
az aks get-credentials --resource-group cosmos-rg --name cosmos-aks
kubectl get nodes
```
