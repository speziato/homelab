# Homelab setup

This repository holds my IaC to manage my homelab.

## Ansible

Currently, the [ansible](ansible) folder contains 2 playbooks:

- [General server setup](ansible/0-init-server.yaml), which installs a bunch of
  packages and configures unattendes upgrades
- [Incus setup](ansible/1-incus.yaml), which installs and configure Incus
