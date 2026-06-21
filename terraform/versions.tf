terraform {
  required_version = ">= 1.6"

  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "~> 1.45"
    }
  }

  # Remote state backend.
  # State holds secrets and the full map of your infra — it must NOT live in git.
  # Point this at a cheap S3-compatible bucket (e.g. Cloudflare R2) once it exists:
  #
  # backend "s3" {
  #   bucket = "cosmos-tfstate"
  #   key    = "infra/terraform.tfstate"
  #   region = "auto"
  #   # endpoint + skip flags for R2 go here
  # }
}

provider "hcloud" {
  token = var.hcloud_token
}
