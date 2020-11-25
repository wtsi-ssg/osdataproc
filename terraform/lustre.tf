# Attach Lustre provider network, if necessary

resource "openstack_compute_interface_attach_v2" "lustre" {
  count = local.with_lustre ? var.workers + 1 : 0

  instance_id = concat([openstack_compute_instance_v2.spark_master.id], openstack_compute_instance_v2.spark_worker[*].id)[count.index]
  port_id     = module.networking.lustre_ports[count.index]
}
