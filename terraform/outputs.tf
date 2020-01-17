output "spark_master_public_ip" {
  value = openstack_networking_floatingip_v2.public_ip.0.address
}
