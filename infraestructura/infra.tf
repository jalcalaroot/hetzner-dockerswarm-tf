### ingresar token
variable "hcloud_token" {}
# Configure the Hetzner Cloud Provider
provider "hcloud" {
  token = "${var.hcloud_token}"
}
###----------------------------
# crear key
resource "hcloud_ssh_key" "newmain" {
  name       = "mewmain"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCV5cpyLKrwaq3muLIvoUoHIUxIXFfpet4+vtxyBduE/owduiROsvhlRV7tMwWZWV5PfYWWsnyAhs5F6nBe6em7PEAWPoDmjoQW6JyKfCvL47m8ftDdfmQPGkIHeeSJYqBLzBkqhcp9ZdvO3Kt594qdpFdXueUxmNkXQGZ/2cu3XGHaMOdbGLgEqnGGEj71LDKH3dr3JbOTtCCA0fkzo8les9ON1pfjyxMJYU82zm9sgUc3J/tLjduGnzgl2kN73vn667/7kBadcVtP13NuXrieAjREZhU/OUC4+upp1qi+2IuDkRNEIHCt0ujev2f57yIQ0xOQ9U13K36Ksmg2IR3f jalcalaroot@jalcalaroot-ThinkPad-T450"
}
###----------------------------
resource "hcloud_server" "dev1" {
  name        = "dev1"
  image       = "ubuntu-16.04"
  server_type = "cx11"
  ssh_keys    = ["${hcloud_ssh_key.newmain.name}"]
  user_data    = "${file("deploy.sh")}"
}
output "public_ip_dev1" {
  value = "${hcloud_server.dev1.ipv4_address}"
}
###----------------------------
resource "hcloud_server" "test1" {
  name        = "test1"
  image       = "ubuntu-16.04"
  server_type = "cx11"
  ssh_keys    = ["${hcloud_ssh_key.newmain.name}"]
  user_data    = "${file("deploy.sh")}"
}
output "public_ip_test1" {
  value = "${hcloud_server.test1.ipv4_address}"
}
###----------------------------
resource "hcloud_server" "prod1" {
  name        = "prod1"
  image       = "ubuntu-16.04"
  server_type = "cx11"
  ssh_keys    = ["${hcloud_ssh_key.newmain.name}"]
  user_data    = "${file("deploy.sh")}"
}
output "public_ip_prod1" {
  value = "${hcloud_server.prod1.ipv4_address}"
}
###----------------------------
resource "hcloud_server" "runners" {
  name        = "runners"
  image       = "ubuntu-16.04"
  server_type = "cx11"
  ssh_keys    = ["${hcloud_ssh_key.newmain.name}"]
  user_data    = "${file("runners.sh")}"
}
output "public_ip_runners" {
  value = "${hcloud_server.runners.ipv4_address}"
}

