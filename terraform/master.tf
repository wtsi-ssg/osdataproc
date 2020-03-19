resource "openstack_networking_secgroup_v2" "spark_master" {
  name = "${var.os_user_name}-${var.cluster_name}-master-secgroup"
}

resource "openstack_networking_secgroup_rule_v2" "spark_master_ssh" {
  direction         = "ingress"
  ethertype         = "IPv4"
  description       = "Allows inbound ssh connections"
  protocol          = "tcp"
  port_range_min    = 22
  port_range_max    = 22
  security_group_id = openstack_networking_secgroup_v2.spark_master.id
}

resource "openstack_networking_secgroup_rule_v2" "spark_master_main_in" {
  direction         = "ingress"
  ethertype         = "IPv4"
  description       = "Allows inbound connections to Spark master"
  protocol          = "tcp"
  port_range_min    = 7077
  port_range_max    = 7077
  security_group_id = openstack_networking_secgroup_v2.spark_master.id
}

resource "openstack_networking_secgroup_rule_v2" "spark_master_hdfs" {
  direction         = "ingress"
  ethertype         = "IPv4"
  description       = "Allows inbound connections to HDFS"
  protocol          = "tcp"
  port_range_min    = 9820
  port_range_max    = 9820
  security_group_id = openstack_networking_secgroup_v2.spark_master.id
}

resource "openstack_networking_secgroup_rule_v2" "spark_master_http_in" {
  direction         = "ingress"
  ethertype         = "IPv4"
  description       = "Allows inbound connections to http server"
  protocol          = "tcp"
  port_range_min    = 80
  port_range_max    = 80
  security_group_id = openstack_networking_secgroup_v2.spark_master.id
}

resource "openstack_networking_secgroup_rule_v2" "spark_master_slave_in" {
  direction         = "ingress"
  ethertype         = "IPv4"
  description       = "Allows inbound connections from any slave node"
  protocol          = "tcp"
  remote_group_id   = openstack_networking_secgroup_v2.spark_slave.id
  security_group_id = openstack_networking_secgroup_v2.spark_master.id
}

resource "openstack_compute_instance_v2" "spark_master" {
  name            = "${var.os_user_name}-${var.cluster_name}-master"
  image_name      = var.image_name
  flavor_name     = var.flavor_name
  key_pair        = openstack_compute_keypair_v2.spark_keypair[0].id
  security_groups = [openstack_networking_secgroup_v2.spark_master.id]
 
  network {
    name = var.network_name
  }

  provisioner "local-exec" {
    command = "echo '[spark_master]\nubuntu@${openstack_networking_floatingip_v2.public_ip.0.address}' > terraform.tfstate.d/${var.cluster_name}/hosts_master"
  }
}

resource "openstack_compute_volume_attach_v2" "spark_volume" {
  count       = var.nfs_volume_id == "" ? 0 : 1
  instance_id = openstack_compute_instance_v2.spark_master.id
  volume_id   = var.nfs_volume_id
}
