resource "openstack_networking_port_v2" "spark_master" {
  name               = "${local.name_prefix}-master-port"
  network_id         = data.openstack_networking_network_v2.network_id.id
  security_group_ids = [module.security_groups.master]
}

resource "openstack_compute_instance_v2" "spark_master" {
  name            = "${local.name_prefix}-master"
  image_name      = var.image_name
  flavor_name     = var.flavor_name
  key_pair        = openstack_compute_keypair_v2.spark_keypair[0].id

  network {
    port = openstack_networking_port_v2.spark_master.id
  }

  # NOTE This writes out the Ansible host inventory... We can probably
  # do this with the local provider...
  provisioner "local-exec" {
    command = var.spark_master_public_ip == "" ? "echo '[spark_master]\nubuntu@${openstack_networking_floatingip_v2.public_ip.0.address}' > terraform.tfstate.d/${var.cluster_name}/hosts_master" : "echo '[spark_master]\nubuntu@${var.spark_master_public_ip}' > terraform.tfstate.d/${var.cluster_name}/hosts_master"
  }
}

resource "openstack_compute_volume_attach_v2" "spark_volume" {
  count       = var.nfs_volume == "" ? 0 : 1
  instance_id = openstack_compute_instance_v2.spark_master.id
  volume_id   = var.nfs_volume
}
