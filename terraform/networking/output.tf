# List of main networking port and Lustre port, if available
output "master_network" {
  value = concat(
    [{port = openstack_networking_port_v2.master.id}],
    local.with_lustre ? [{port = openstack_networking_port_v2.lustre[0].id}] : []
  )
}

# Same as above, but for each worker
output "worker_network" {
  value = [for i in range(var.workers): concat(
    [{port = openstack_networking_port_v2.worker[i].id}],
    local.with_lustre ? [{port = openstack_networking_port_v2.lustre[i + 1].id}] : []
  )]
}

output "worker_ips" {
  value = openstack_networking_port_v2.worker[*].all_fixed_ips
}

output "floating_ip" {
  value = local.create_ip ? openstack_networking_floatingip_v2.floating_ip[0].address : var.floating_ip
}
