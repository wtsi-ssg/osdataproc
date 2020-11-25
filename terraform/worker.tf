# TODO cloud-init template

resource "openstack_compute_instance_v2" "spark_worker" {
  count = var.workers

  name        = format("${local.name_prefix}-worker-%02d", count.index + 1)
  image_name  = var.image_name
  flavor_name = var.flavor_name
  key_pair    = openstack_compute_keypair_v2.spark_keypair.id
  user_data   = templatefile("user_data.sh.tpl", {
                  spark_master_private_ip = openstack_compute_instance_v2.spark_master.access_ip_v4,
                  user                    = var.username,
                  cluster                 = var.cluster_name,
                  workers                 = var.workers,
                  worker_ips              = jsonencode(module.networking.worker_ips),
                  netdata_api_key         = var.netdata_api_key,
                  nfs_volume              = var.nfs_volume
                })

  network {
    port = module.networking.worker_ports[count.index]
  }
}
