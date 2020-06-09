resource "openstack_networking_secgroup_v2" "spark_worker" {
  name = "${var.os_user_name}-${var.cluster_name}-worker-secgroup"
}

resource "openstack_networking_secgroup_rule_v2" "spark_worker_master_in" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  remote_group_id   = openstack_networking_secgroup_v2.spark_master.id
  security_group_id = openstack_networking_secgroup_v2.spark_worker.id
}

resource "openstack_networking_secgroup_rule_v2" "spark_worker_worker_in" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  remote_group_id   = openstack_networking_secgroup_v2.spark_worker.id
  security_group_id = openstack_networking_secgroup_v2.spark_worker.id
}

resource "openstack_networking_port_v2" "spark_worker" {
  name               = format("${var.os_user_name}-${var.cluster_name}-worker-port-%02d", count.index+1)
  count              = var.workers
  network_id         = data.openstack_networking_network_v2.network_id.id
  security_group_ids = [openstack_networking_secgroup_v2.spark_worker.id]
}

resource "openstack_compute_instance_v2" "spark_worker" {
  name            = format("${var.os_user_name}-${var.cluster_name}-worker-%02d",count.index+1)
  count           = var.workers
  image_name      = var.image_name
  flavor_name     = var.flavor_name
  key_pair        = openstack_compute_keypair_v2.spark_keypair[0].id
  user_data       = templatefile("user_data.sh.tpl", 
                      {spark_master_private_ip = openstack_compute_instance_v2.spark_master.access_ip_v4,
                       user                    = var.os_user_name,
                       cluster                 = var.cluster_name,
                       workers                  = var.workers,
                       worker_ips               = jsonencode(openstack_networking_port_v2.spark_worker.*.all_fixed_ips),
                       netdata_api_key         = var.netdata_api_key,
                       nfs_volume              = var.nfs_volume})

  network {
    port = element(openstack_networking_port_v2.spark_worker.*.id,count.index)
  }
}
