resource "openstack_networking_secgroup_v2" "spark_slave" {
  name = "${var.os_user_name}-${var.cluster_name}-slave-secgroup"
}

resource "openstack_networking_secgroup_rule_v2" "spark_slave_master_in" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  remote_group_id   = openstack_networking_secgroup_v2.spark_master.id
  security_group_id = openstack_networking_secgroup_v2.spark_slave.id
}

resource "openstack_networking_secgroup_rule_v2" "spark_slave_slave_in" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  remote_group_id   = openstack_networking_secgroup_v2.spark_slave.id
  security_group_id = openstack_networking_secgroup_v2.spark_slave.id
}

resource "openstack_networking_port_v2" "spark_slave" {
  name               = format("${var.os_user_name}-${var.cluster_name}-slave-port-%02d", count.index+1)
  count              = var.slaves
  network_id         = data.openstack_networking_network_v2.network_id.id
  security_group_ids = [openstack_networking_secgroup_v2.spark_slave.id]
}

resource "openstack_compute_instance_v2" "spark_slave" {
  name            = format("${var.os_user_name}-${var.cluster_name}-slave-%02d",count.index+1)
  count           = var.slaves
  image_name      = var.image_name
  flavor_name     = var.flavor_name
  key_pair        = openstack_compute_keypair_v2.spark_keypair[0].id
  user_data       = templatefile("user_data.sh.tpl", 
                      {spark_master_private_ip = openstack_compute_instance_v2.spark_master.access_ip_v4,
                       user                    = var.os_user_name,
                       cluster                 = var.cluster_name,
                       slaves                  = var.slaves,
                       slave_ips               = jsonencode(openstack_networking_port_v2.spark_slave.*.all_fixed_ips),
                       netdata_api_key         = var.netdata_api_key,
                       nfs_volume              = var.nfs_volume})

  network {
    port = element(openstack_networking_port_v2.spark_slave.*.id,count.index)
  }
}
