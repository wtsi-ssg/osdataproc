provider "openstack" {}

module "security_groups" {
  source     = "./security-groups"
  identifier = local.name_prefix
}

module "networking" {
  source = "./networking"

  identifier      = local.name_prefix
  workers         = var.workers
  network_name    = var.network_name
  lustre_network  = var.lustre_network
  floating_ip     = var.spark_master_public_ip
  security_groups = module.security_groups
}

resource "openstack_compute_keypair_v2" "spark_keypair" {
  name       = "${local.name_prefix}-keypair"
  public_key = var.identity_file
}

# Master

resource "openstack_compute_instance_v2" "spark_master" {
  name        = "${local.name_prefix}-master"
  image_name  = var.image_name
  flavor_name = var.flavor_name
  key_pair    = openstack_compute_keypair_v2.spark_keypair.id
  network     = module.networking.master_network

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

# Workers

# TODO cloud-init template

resource "openstack_compute_instance_v2" "spark_worker" {
  count = var.workers

  name        = format("${local.name_prefix}-worker-%02d", count.index + 1)
  image_name  = var.image_name
  flavor_name = var.flavor_name
  key_pair    = openstack_compute_keypair_v2.spark_keypair.id
  network     = module.networking.worker_network[count.index]
  user_data   = templatefile("user_data.sh.tpl", {
                  spark_master_private_ip = openstack_compute_instance_v2.spark_master.access_ip_v4,
                  user                    = var.username,
                  cluster                 = var.cluster_name,
                  workers                 = var.workers,
                  worker_ips              = jsonencode(module.networking.worker_ips),
                  netdata_api_key         = var.netdata_api_key,
                  nfs_volume              = var.nfs_volume
                })
}
