# Homelab setup

This repository holds my IaC to manage my homelab.

## IaC

This branch contains configuration to create all LXCs and VMs in the Proxmox hypervisor using the [telmate/proxmox](https://search.opentofu.org/provider/telmate/proxmox/latest) provider.

### Caveats

In order to allow LXCs to specify filesystem mountpoints, which I needed for shared volumes across multiple LXCs,
you have to invoke the Proxmox APIs with the `root` user and password. There is no other way to make those work ATM.

Those are the relevant variables in the `secrets/.env` file:

```bash
TF_VAR_PVE_USER = "root@pam"
TF_VAR_PVE_PASSWORD = "root-password"
```

and those are the relevant parameters in `main.tf`:

```hcl
provider "proxmox" {
  ...
  pm_user = var.PVE_USER
  pm_password = var.PVE_PASSWORD
  ...
}
```

It's ugly.

### Importing resources

If there are VMs/LXCs that exist in the hypervisor and do not exist in the TF state, you can import them:

- run `mise run import`
  - it will ask for the type (`vm`/`lxc`), the ID and the name of the resource to be imported
  - it will then create a file named `<type>_<name>.tf` that contains the imported data for the resource
- run `tofu plan` and `tofu apply` as usual
