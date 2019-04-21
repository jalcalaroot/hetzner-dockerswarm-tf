output "public_ip_master" {
  value = "${hcloud_server.master.ipv4_address}"
}
output "public_ip_node1" {
  value = "${hcloud_server.node1.ipv4_address}"
}
output "public_ip_node2" {
  value = "${hcloud_server.node2.ipv4_address}"
}
output "public_ip_node3" {
  value = "${hcloud_server.node3.ipv4_address}"
}
output "public_ip_runner" {
  value = "${hcloud_server.runner.ipv4_address}"
}
