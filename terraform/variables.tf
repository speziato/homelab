variable "PVE_API_TOKEN_ID" {
  type = string
  description = "API Token ID to authenticate requests to Proxmox"
  nullable = true
  default = ""
}

variable "PVE_API_TOKEN_SECRET" {
  type = string
  description = "API Token secret to authenticate requests to Proxmox"
  nullable = true
  sensitive = true
  default = ""
}

variable "PVE_INSECURE" {
  type = string
  description = "Wether to ignore invalid/self-signed TLS certificates"
  default = true
}

variable "PVE_ENDPOINT" {
  type = string
  description = "The endpoint of the Proxmox server"
  nullable = false
}

variable "PVE_USER" {
  type = string
  description = "The user to authenticate into Proxmox"
  nullable = true
}

variable "PVE_PASSWORD" {
  type = string
  description = "The password to be used to authenticate into Proxmox"
  nullable = true
}