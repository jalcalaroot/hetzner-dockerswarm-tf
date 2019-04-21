### ingresar token
variable "hcloud_token" {}
# Configure the Hetzner Cloud Provider
provider "hcloud" {
  token = "${var.hcloud_token}"
}
###----------------------------
# crear key
resource "hcloud_ssh_key" "main" {
 name       = "main"
 public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCV5cpyLKrwaq3muLIvoUoHIUxIXFfpet4+vtxyBduE/owduiROsvhlRV7tMwWZWV5PfYWWsnyAhs5F6nBe6em7PEAWPoDmjoQW6JyKfCvL47m8ftDdfmQPGkIHeeSJYqBLzBkqhcp9ZdvO3Kt594qdpFdXueUxmNkXQGZ/2cu3XGHaMOdbGLgEqnGGEj71LDKH3dr3JbOTtCCA0fkzo8les9ON1pfjyxMJYU82zm9sgUc3J/tLjduGnzgl2kN73vn667/7kBadcVtP13NuXrieAjREZhU/OUC4+upp1qi+2IuDkRNEIHCt0ujev2f57yIQ0xOQ9U13K36Ksmg2IR3f jalcalaroot@jalcalaroot-ThinkPad-T450"
}
###----------------------------
resource "hcloud_server" "master" {
  name        = "master"
  image       = "ubuntu-16.04"
  server_type = "cx11"
  ssh_keys    = ["${hcloud_ssh_key.main.name}"]
  user_data    = "${file("master.sh")}"
}
###----------------------------
resource "hcloud_server" "node1" {
  name        = "node1"
  image       = "ubuntu-16.04"
  server_type = "cx11"
  ssh_keys    = ["${hcloud_ssh_key.main.name}"]
  user_data    = "${file("nodes.sh")}"
}
###----------------------------
resource "hcloud_server" "node2" {
  name        = "node2"
  image       = "ubuntu-16.04"
  server_type = "cx11"
  ssh_keys    = ["${hcloud_ssh_key.main.name}"]
  user_data    = "${file("nodes.sh")}"
}
###----------------------------
resource "hcloud_server" "node3" {
  name        = "node3"
  image       = "ubuntu-16.04"
  server_type = "cx11"
  ssh_keys    = ["${hcloud_ssh_key.main.name}"]
  user_data    = "${file("nodes.sh")}"
}
###----------------------------
resource "hcloud_server" "runner" {
  name        = "runner"
  image       = "ubuntu-16.04"
  server_type = "cx11"
  ssh_keys    = ["${hcloud_ssh_key.main.name}"]
  user_data    = "${file("runners.sh")}"
}
