
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

# This is the root key we use to access and provison
# servers at the hetzner provider. If not present, it
# will be created under the given name
resource "hcloud_ssh_key" "default" {
  name       = "o12stack"
  public_key = "${file("~/.ssh/hetzner-o12stack.id_rsa.pub")}"
}

# We use random pet names to name each workshop
# server: numbers are boooooring
resource "random_pet" "server" {}

# This creates the workshop servers
resource "hcloud_server" "workshop" {
  count       = "${var.instance_count}"
  name        = "${random_pet.server.id}"
  image       = "centos-7"
  server_type = "cx11"
  ssh_keys    = ["${hcloud_ssh_key.default.name}"]
}

resource "digitalocean_record" "www" {
  domain = "k8s.o12stack.org"
  type   = "A"
  name   = "${hcloud_server.workshop.name}"
  value  = "${hcloud_server.workshop.ipv4_address}"
}