output "spark_worker_private_ips" {
  value = openstack_compute_instance_v2.spark_worker.*.network.0.fixed_ip_v4
  // sensitive to stop unnecessary CLI output, but still parsable in created outputs.json file
  sensitive = true
}

output "spark_master_private_ip" {
  value = openstack_compute_instance_v2.spark_master.access_ip_v4
  sensitive = true
}

output "spark_master_public_ip" {
  value = var.spark_master_public_ip == "" ? openstack_networking_floatingip_v2.public_ip.0.address : var.spark_master_public_ip
}
