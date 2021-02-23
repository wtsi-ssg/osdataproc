output "master_ports" {
  value = concat(
    [openstack_networking_port_v2.master.id],
    local.with_lustre ? [openstack_networking_port_v2.lustre[0].id] : []
  )
}

output "workers_ports" {
  value = [for idx in range(var.workers):
    concat(
      [openstack_networking_port_v2.worker[idx].id],
      local.with_lustre ? [openstack_networking_port_v2.lustre[idx + 1].id] : []
    )
  ]
}

output "worker_ips" {
  value = flatten(openstack_networking_port_v2.worker[*].all_fixed_ips)
}

output "floating_ip" {
  value = local.create_ip ? openstack_networking_floatingip_v2.floating_ip[0].address : var.floating_ip
}
