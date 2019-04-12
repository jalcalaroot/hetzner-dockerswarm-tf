### ingresar token
variable "hcloud_token" {}
# Configure the Hetzner Cloud Provider
provider "hcloud" {
  token = "${var.hcloud_token}"
}
###----------------------------
# crear key
resource "hcloud_ssh_key" "default" {
  name       = "main ssh key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDMB5nWb9EnoI73dTW4Lt8q5NoDDImkB6XlNE5UYr52QDDFexWhkWeHTA8OiaGme3qDqgvbwyRDLEIXxZNGxBOuIYK31hysYHkwKnWcZXb2wJAgrqBDw0F5KYX9z3cBRltnM1NcxRhF8wzb9Sg2Akhu2fEEiZuIY2ds8tr+rIv3xoZ2GIh6k++z8Zyl6ssw8fI/1aBNuSBp2pGBQzXFG1D/JUhXkuPgD+fVNgTW2cNxIRqrUO6fftUR9x19AIoqlRZYYY+ywYs7jpW7v7MLtae+5KK/l5RbDHAVOqSV4jfj517NIeGZxIlAswpqwNKOT2LmOkb9OIZauoSWV4yjkywT jalcalaroot@jalcalaroot-ThinkPad-T450"
}
###----------------------------
resource "hcloud_server" "server-runners" {
  name        = "server-runners"
  image       = "ubuntu-16.04"
  server_type = "cx11"
  ssh_keys    = ["${hcloud_ssh_key.default.name}"]
  user_data    = "${file("deploy2.sh")}"
}
output "public_ip4-1" {
  value = "${hcloud_server.server-runners.ipv4_address}"
}
###----------------------------
resource "hcloud_server" "server1" {
  name        = "server1"
  image       = "ubuntu-16.04"
  server_type = "cx11"
  ssh_keys    = ["${hcloud_ssh_key.default.name}"]
  user_data    = "${file("deploy.sh")}"
}
output "public_ip4-1" {
  value = "${hcloud_server.server1.ipv4_address}"
}
###----------------------------
resource "hcloud_server" "server2" {
  name        = "server2"
  image       = "ubuntu-16.04"
  server_type = "cx11"
  ssh_keys    = ["${hcloud_ssh_key.default.name}"]
  user_data    = "${file("deploy.sh")}"
}
output "public_ip4-2" {
  value = "${hcloud_server.server2.ipv4_address}"
}
###----------------------------
resource "hcloud_server" "server3" {
  name        = "server3"
  image       = "ubuntu-16.04"
  server_type = "cx11"
  ssh_keys    = ["${hcloud_ssh_key.default.name}"]
  user_data    = "${file("deploy.sh")}"
}
output "public_ip4-3" {
  value = "${hcloud_server.server3.ipv4_address}"
}

