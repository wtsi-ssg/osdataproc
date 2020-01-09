// TODO if user specifies public ip (spark_master_public_ip="172.x.x.x")
// then do not create a new one
resource "openstack_networking_floatingip_v2" "public_ip" {
  count   = var.spark_master_public_ip == "" ? 1 : 0
  address = var.spark_master_public_ip
  pool    = var.os_interface
}

resource "openstack_compute_floatingip_associate_v2" "public_ip" {
  count       = 1
  floating_ip = var.spark_master_public_ip == "" ? openstack_networking_floatingip_v2.public_ip[count.index].address : var.spark_master_public_ip
  instance_id = openstack_compute_instance_v2.spark_master[count.index].id
}

resource "openstack_compute_keypair_v2" "spark_keypair" {
  //name = var.spark_keypair == "None" ? "spark_keypair" : var.spark_keypair
  name = "spark_keypair"
  count = var.spark_keypair == "None" ? 1 : 0
  public_key = var.identity_file
}
