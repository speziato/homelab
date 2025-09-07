terraform {
  required_providers {
    proxmox = {
      source = "telmate/proxmox"
      version = "3.0.2-rc04"
    }
  }
  backend "local" {
    path = "secrets/terraform.tfstate"
  }
}

provider "proxmox" {
  pm_api_url = var.PVE_ENDPOINT
  pm_tls_insecure = var.PVE_INSECURE
  # pm_api_token_id = var.PVE_API_TOKEN_ID
  # pm_api_token_secret = var.PVE_API_TOKEN_SECRET
  pm_user = var.PVE_USER
  pm_password = var.PVE_PASSWORD
  # ssh {
  #   agent = false
  #   username = var.PVE_SSH_USER
  #   private_key = var.PVE_SSH_PRIVATE_KEY
  # }
}
