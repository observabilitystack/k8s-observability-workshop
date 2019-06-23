# Workshop cluster setup

This folder holds resources to set up a general workshop 
cluster where

* Each participant can work on it's own server
* The participants can edit the relevant workshop files transparently via SSH/VSCode
* technically, all infrastructure is set up (and destroyed) using Terraform
* All servers are provisioned using Ansible

![alt](docs/workshop-login.png)

## Setting up the cluster

### Weeks before the workshop

We are hosting the servers at [Hetzner](https://accounts.hetzner.com) and DNS for free at [Digital Ocean](https://cloud.digitalocean.com/). So make sure, you have accounts and
API access tokens in place (`HCLOUD_TOKEN` and `DIGITALOCEAN_TOKEN`).

Contact the participants and aks them for their SSH public key.

### The day before the workshop

Prepare your local machine for cluster setup:

```
brew install terraform@0.11 ansible terraform-inventory figlet
brew link terraform@0.11 --force
```

> We need to stick to Terraform 0.11 until this PR is merged in [terraform-inventory](https://github.com/adammck/terraform-inventory/pull/114)!

```
tf init
tf plan
tf apply
ansible-playbook site.yml
```

### The day after the workshop

```
tf destroy
```
