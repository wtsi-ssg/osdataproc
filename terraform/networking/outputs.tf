output "master_port" {
  value = openstack_networking_port_v2.master.id
}

output "worker_ports" {
  value = openstack_networking_port_v2.worker[*].id
}

output "lustre_ports" {
  value = local.with_lustre ? openstack_networking_port_v2.lustre[*].id : []
}

output "worker_ips" {
  value = flatten(openstack_networking_port_v2.worker[*].all_fixed_ips)
}

output "floating_ip" {
  value = local.create_ip ? openstack_networking_floatingip_v2.floating_ip[0].address : var.floating_ip
}
