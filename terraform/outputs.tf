output "spark_worker_private_ips" {
  # FIXME? Is this the same as module.networking.worker_ips?...
  value     = openstack_compute_instance_v2.spark_worker[*].network[0].fixed_ip_v4
  sensitive = true
}

output "spark_master_private_ip" {
  value     = openstack_compute_instance_v2.spark_master.access_ip_v4
  sensitive = true
}

output "spark_master_public_ip" {
  value = module.networking.floating_ip
}
