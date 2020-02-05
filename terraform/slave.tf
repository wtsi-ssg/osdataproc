resource "openstack_networking_secgroup_v2" "spark_slave" {
  name = "${var.os_user_name}-${var.cluster_name}-slaves-secgroup"
}

resource "openstack_networking_secgroup_rule_v2" "spark_slave_all" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 1
  port_range_max    = 65535
  security_group_id = openstack_networking_secgroup_v2.spark_slave.id
}

resource "openstack_compute_instance_v2" "spark_slave" {
  name            = format("${var.os_user_name}-${var.cluster_name}-slave-%02d",count.index+1)
  count           = var.slaves
  image_name      = var.image_name
  flavor_name     = var.flavor_name
  key_pair        = openstack_compute_keypair_v2.spark_keypair[0].id
  security_groups = [openstack_networking_secgroup_v2.spark_slave.id]
  user_data       = templatefile("user_data.sh.tpl", { spark_master_private_ip = openstack_compute_instance_v2.spark_master.access_ip_v4 })

  network {
    name = var.network_name
  }
}
