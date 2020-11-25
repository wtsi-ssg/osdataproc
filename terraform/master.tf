resource "openstack_compute_instance_v2" "spark_master" {
  name        = "${local.name_prefix}-master"
  image_name  = var.image_name
  flavor_name = var.flavor_name
  key_pair    = openstack_compute_keypair_v2.spark_keypair.id

  network {
    port = module.networking.master_port
  }

  # NOTE This writes out the Ansible host inventory... We can probably
  # do this with the local provider...
  provisioner "local-exec" {
    command = "echo '[spark_master]\nubuntu@${module.networking.floating_ip}' > terraform.tfstate.d/${var.cluster_name}/hosts_master"
  }
}

resource "openstack_compute_volume_attach_v2" "spark_volume" {
  count       = var.nfs_volume == "" ? 0 : 1
  instance_id = openstack_compute_instance_v2.spark_master.id
  volume_id   = var.nfs_volume
}

resource "openstack_compute_floatingip_associate_v2" "public_ip" {
  floating_ip = module.networking.floating_ip
  instance_id = openstack_compute_instance_v2.spark_master.id
}
