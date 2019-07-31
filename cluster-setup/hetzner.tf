
terraform {
  # we are limited to this version until the terraform-inventory
  # works with 0.12s
  required_version = "~> 0.11"
  
  # synchronize cluster state across trainers
  backend "remote" {
    organization = "o12stack"
    workspaces {
      name = "wjax-k8s-workshop"
    }

    # credentials are read from .terraformrc
  }
}

variable "instance_count" {
  default = "1"
}

# Configure the Hetzner Cloud Provider using
# a token from our enviornment
provider "hcloud" {
  version = "~> 1.10"
}

# We use Digital Ocean for DNS
provider "digitalocean" {
  version = "~> 1.4"
}

# we use the random provider to assign
# random hostnames
provider "random" {
  version = "~> 2.1"
}

# Obtain TLS certs from Let's Encrypt
provider "acme" {
  version = "~> 1.3"
  server_url = "https://acme-v02.api.letsencrypt.org/directory"
#  server_url = "https://acme-staging-v02.api.letsencrypt.org/directory"
}

# Use this to create ACME tls private keys
provider "tls" {
  version = "~> 2.0"
}

# Use this to write ACME certs to file
provider "local" {
  version = "~> 1.2"
}

# This is the root key we use to access and provison
# servers at the hetzner provider. If not present, it
# will be created under the given name
resource "hcloud_ssh_key" "default" {
  name       = "o12stack"
  public_key = "${file("~/.ssh/hetzner-o12stack.id_rsa.pub")}"
}

# We use random pet names to name each workshop
# server: numbers are boooooring
resource "random_pet" "server" {
  count       = "${var.instance_count}"
}

# This creates the workshop servers. Increase count
# to the number of participants
resource "hcloud_server" "workshop" {
  count       = "${var.instance_count}"
  name        = "${element(random_pet.server.*.id, count.index)}"
  image       = "centos-7"
  server_type = "cx51"   # 8cpu
  ssh_keys    = ["${hcloud_ssh_key.default.name}"]
}

# This creates a DNS record as a subdomain of
# k8s.012stack.org that points to the host
resource "digitalocean_record" "hostname" {
  count  = "${var.instance_count}"
  domain = "k8s.o12stack.org"
  type   = "A"
  name   = "${element(hcloud_server.workshop.*.name, count.index)}"
  value  = "${element(hcloud_server.workshop.*.ipv4_address, count.index)}"
}

# This creates a wildcard subdomain pointing to
# the hostname. We use this for different services
# on our workshop servers later
resource "digitalocean_record" "wildcard" {
  count  = "${var.instance_count}"
  domain = "k8s.o12stack.org"
  type   = "CNAME"
  name   = "*.${element(hcloud_server.workshop.*.name, count.index)}"
  value  = "${element(hcloud_server.workshop.*.name, count.index)}.k8s.o12stack.org."
}

# Create a private key to request TLS certs with
resource "tls_private_key" "private_key" {
  algorithm = "RSA"
}

# Register an account with ACMEs
resource "acme_registration" "o12stack" {
  account_key_pem = "${tls_private_key.private_key.private_key_pem}"
  email_address   = "nobody@o12stack.org"
}

# Request wildcard TLS cert
resource "acme_certificate" "certificate" {
  count                     = "${var.instance_count}"
  account_key_pem           = "${acme_registration.o12stack.account_key_pem}"
  common_name               = "*.${element(hcloud_server.workshop.*.name, count.index)}.k8s.o12stack.org"
  subject_alternative_names = ["${element(hcloud_server.workshop.*.name, count.index)}.k8s.o12stack.org"]

  dns_challenge {
    provider = "digitalocean"
  }
}

# write TLS certs into Ansible
resource "local_file" "certificates" {
    count    = "${var.instance_count}"
    content  = "${element(acme_certificate.certificate.*.certificate_pem, count.index)}${element(acme_certificate.certificate.*.issuer_pem, count.index)}${element(acme_certificate.certificate.*.private_key_pem, count.index)}"
    filename = "./roles/bootstrap/tls/files/${element(hcloud_server.workshop.*.name, count.index)}.k8s.o12stack.org.pem"
}

