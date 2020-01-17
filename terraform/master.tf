resource "openstack_networking_secgroup_v2" "spark_master" {
  name = "${var.os_user_name}_${var.cluster_name}_master_secgroup"
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
  port_range_min    = 1
  port_range_max    = 65535
  security_group_id = openstack_networking_secgroup_v2.spark_master.id
}

//resource "openstack_networking_secgroup_rule_v2" "spark_master_web_ui" {
//  direction         = "ingress"
//  ethertype         = "IPv4"
//  description       = "Allows inbound connections to Spark Master web UI"
//  protocol          = "tcp"
//  port_range_min    = 8080
//  port_range_max    = 8080
//  security_group_id = openstack_networking_secgroup_v2.spark_master.id
//}
//
//resource "openstack_networking_secgroup_rule_v2" "spark_master_jupyter" {
//  direction         = "ingress"
//  ethertype         = "IPv4"
//  description       = "Allows inbound connections to Jupyter Notebook"
//  protocol          = "tcp"
//  port_range_min    = 8888
//  port_range_max    = 8888
//  security_group_id = openstack_networking_secgroup_v2.spark_master.id
//}
//
//resource "openstack_networking_secgroup_rule_v2" "spark_master_yarn" {
//  direction         = "ingress"
//  ethertype         = "IPv4"
//  description       = "Allows inbound connections to Yarn web UI"
//  protocol          = "tcp"
//  port_range_min    = 8088
//  port_range_max    = 8088
//  security_group_id = openstack_networking_secgroup_v2.spark_master.id
//}
//
//resource "openstack_networking_secgroup_rule_v2" "spark_master_hdfs" {
//  direction         = "ingress"
//  ethertype         = "IPv4"
//  description       = "Allows inbound connections to HDFS web UI"
//  protocol          = "tcp"
//  port_range_min    = 9820
//  port_range_max    = 9870
//  security_group_id = openstack_networking_secgroup_v2.spark_master.id
//}
//
//resource "openstack_networking_secgroup_rule_v2" "spark_master_http_in" {
//  direction         = "ingress"
//  ethertype         = "IPv4"
//  description       = "Allows inbound connections to http server"
//  protocol          = "tcp"
//  port_range_min    = 80
//  port_range_max    = 80
//  security_group_id = openstack_networking_secgroup_v2.spark_master.id
//}
//
//resource "openstack_networking_secgroup_rule_v2" "spark_master_slave_in" {
//  direction         = "ingress"
//  ethertype         = "IPv4"
//  description       = "Allows inbound connections from any slave node"
//  protocol          = "tcp"
//  remote_group_id   = openstack_networking_secgroup_v2.spark_slave.id
//  security_group_id = openstack_networking_secgroup_v2.spark_master.id
//}

resource "openstack_compute_instance_v2" "spark_master" {
  name            = "${var.os_user_name}_${var.cluster_name}_master"
  count           = 1
  image_name      = var.image_name
  flavor_name     = var.master_flavor_name
  key_pair        = var.spark_keypair == "None" ? openstack_compute_keypair_v2.spark_keypair[0].id : var.spark_keypair
  // TODO create security groups
  security_groups = [openstack_networking_secgroup_v2.spark_master.id]
 
// TODO create networks
  network {
    name = "cloudforms_network"
  }

  provisioner "local-exec" {
    command = "echo '[spark_master]\nubuntu@${openstack_networking_floatingip_v2.public_ip.0.address}' > terraform.tfstate.d/${var.cluster_name}/hosts_master"
  }
}
