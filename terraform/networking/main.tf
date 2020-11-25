data "openstack_networking_network_v2" "external" {
  external = true
}

data "openstack_networking_network_v2" "network_id" {
  name = var.network_name
}

data "openstack_networking_network_v2" "lustre_network_id" {
  count = local.with_lustre ? 1 : 0
  name  = var.lustre_network
}

# Floating IP (only create when unspecified)
resource "openstack_networking_floatingip_v2" "floating_ip" {
  count       = local.create_ip ? 1 : 0
  address     = var.floating_ip
  description = "${var.identifier}-spark"
  pool        = data.openstack_networking_network_v2.external.name
}

# Master port
resource "openstack_networking_port_v2" "master" {
  name               = "${var.identifier}-master-port"
  network_id         = data.openstack_networking_network_v2.network_id.id
  security_group_ids = [var.security_groups.master]
}

# Worker ports
resource "openstack_networking_port_v2" "worker" {
  count              = var.workers
  name               = format("${var.identifier}-worker-port-%02d", count.index + 1)
  network_id         = data.openstack_networking_network_v2.network_id.id
  security_group_ids = [var.security_groups.worker]
}

# Lustre provider ports
resource "openstack_networking_port_v2" "lustre" {
  count      = local.with_lustre ? var.workers + 1 : 0
  name       = format("${var.identifier}-lustre-port-%02d", count.index + 1)
  network_id = data.openstack_networking_network_v2.lustre_network_id[0].id
}
