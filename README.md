# cosmos-infra — platform tier

Infrastructure-as-Code for the **platform** the Cosmos services run on: the
Azure resource group + AKS (managed Kubernetes) cluster, one per environment.

This repo does **not** deploy application code. That's the **app tier**, which
lives next to each service (`cosmos-api/iac/<env>/`) and deploys onto the
cluster this repo provisions. The seam between the two tiers is the cluster:
this repo creates it; the app tier connects to it.

## Layout

```
modules/
  aks/                  # the cluster, defined ONCE (reusable, no provider block)
environments/
  int/                  # integration env — thin wrapper: picks the module + sizing
    main.tf             #   module "aks" { source = "../../modules/aks"  environment = "int" ... }
    versions.tf         #   provider + (per-env) remote state backend
    variables.tf        #   subscription_id
    terraform.tfvars    #   (gitignored) your subscription id
.github/workflows/
  terraform-plan.yml    # fmt + validate + plan on PRs touching modules/ or environments/
  terraform-apply.yml   # manual dispatch; gated by a GitHub Environment per env
```

## Why this shape

- **`modules/aks`** holds the cluster definition once. Environments are just
  _inputs_ to it (node count, VM size, region). No duplicated resource blocks.
- **`environments/<env>`** each has its **own state** (own backend `key`), so an
  `int` apply can never read or corrupt `stage`/`prod` state.
- **Adding a lower environment is a recipe, not a rewrite:** copy
  `environments/int/` → `environments/<new>/`, change `environment` and the
  sizing, add a matching GitHub Environment, and add it to the apply workflow's
  `environment` choice list.

## Environments

| Env              | Status      | Notes                                                 |
| ---------------- | ----------- | ----------------------------------------------------- |
| `int`            | active      | the only one provisioned right now, to keep cost down |
| `stage` / `prod` | not created | add via the recipe above when needed                  |

## Cost

- **Control plane:** Free tier ($0) per cluster.
- **Node:** one `Standard_B2als_v2` (2 vCPU / 4 GiB), billed per hour it runs
  (~$32/mo always-on). Use `terraform destroy` between sessions to pay only for
  active hours.
- New accounts get a $200 / 30-day credit — month one is effectively free.

## Local usage

```bash
az login                                          # authenticate
cd environments/int
cp terraform.tfvars.example terraform.tfvars      # then fill in subscription_id
terraform init
terraform plan
terraform apply

# Point kubectl at the new cluster (the apply output prints this command):
az aks get-credentials --resource-group cosmos-int-rg --name cosmos-int-aks
kubectl get nodes
```

## Security — read before committing

- **Never commit** `*.tfstate` or `*.tfvars`. They are gitignored.
- `terraform.tfvars.example` is the safe template — copy it to `terraform.tfvars`
  (gitignored) and fill in your subscription ID.
- Local auth is via `az login` (no client secret stored).
- CI auth is via Azure OIDC federation — repo secrets `AZURE_CLIENT_ID`,
  `AZURE_TENANT_ID`, `AZURE_SUBSCRIPTION_ID`, never a committed secret.
- Remote state should live in an Azure Storage account, configured per env in
  `environments/<env>/versions.tf` with a distinct `key`. **Until that's wired
  up, CI `apply` won't persist state between runs — apply from local for now.**

```

test pr
```
