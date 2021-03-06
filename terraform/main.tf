// if user specifies public ip (spark_master_public_ip="x.x.x.x")
// then do not create a new one
resource "openstack_networking_floatingip_v2" "public_ip" {
  count   = var.spark_master_public_ip == "" ? 1 : 0
  address = var.spark_master_public_ip
  pool    = var.os_interface
}

resource "openstack_compute_floatingip_associate_v2" "public_ip" {
  count       = 1
  floating_ip = var.spark_master_public_ip == "" ? openstack_networking_floatingip_v2.public_ip[count.index].address : var.spark_master_public_ip
  instance_id = openstack_compute_instance_v2.spark_master.id
}

resource "openstack_compute_keypair_v2" "spark_keypair" {
  name = "${var.os_user_name}_${var.cluster_name}_keypair"
  count = 1
  public_key = var.identity_file
}

data "openstack_networking_network_v2" "network_id" {
  name = var.network_name
}

