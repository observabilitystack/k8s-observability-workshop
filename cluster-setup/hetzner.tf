# Set the variable value in *.tfvars file
# or using -var="hcloud_token=..." CLI option
variable "HCLOUD_TOKEN" {}

variable "instance_count" {
  default = "1"
}

# Configure the Hetzner Cloud Provider using
# a token from our enviornment
provider "hcloud" {
  token = "${var.HCLOUD_TOKEN}"
  version = "~> 1.10"
}

# This is the root key we use to access and provison
# servers at the hetzner provider. If not present, it
# will be created under the given name
resource "hcloud_ssh_key" "default" {
  name       = "o12stack"
  public_key = "${file("~/.ssh/hetzner-o12stack.id_rsa.pub")}"
}

# This creates the workshop servers
resource "hcloud_server" "workshop" {
  count       = "${var.instance_count}"
  name        = "workshop-${count.index}"
  image       = "centos-7"
  server_type = "cx11"
  ssh_keys    = ["${hcloud_ssh_key.default.name}"]
}
