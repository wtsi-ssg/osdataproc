resource "openstack_networking_secgroup_v2" "master" {
  name = "${var.name}-master"
}

resource "openstack_networking_secgroup_rule_v2" "spark_master_ssh" {
  direction         = "ingress"
  ethertype         = "IPv4"
  description       = "Allows inbound ssh connections"
  protocol          = "tcp"
  port_range_min    = 22
  port_range_max    = 22
  security_group_id = openstack_networking_secgroup_v2.master.id
}

resource "openstack_networking_secgroup_rule_v2" "spark_master_main_in" {
  direction         = "ingress"
  ethertype         = "IPv4"
  description       = "Allows inbound connections to Spark master"
  protocol          = "tcp"
  port_range_min    = 7077
  port_range_max    = 7077
  security_group_id = openstack_networking_secgroup_v2.master.id
}

resource "openstack_networking_secgroup_rule_v2" "spark_master_hdfs" {
  direction         = "ingress"
  ethertype         = "IPv4"
  description       = "Allows inbound connections to HDFS"
  protocol          = "tcp"
  port_range_min    = 9820
  port_range_max    = 9820
  security_group_id = openstack_networking_secgroup_v2.master.id
}

resource "openstack_networking_secgroup_rule_v2" "spark_master_http_in" {
  direction         = "ingress"
  ethertype         = "IPv4"
  description       = "Allows inbound connections to http server"
  protocol          = "tcp"
  port_range_min    = 80
  port_range_max    = 80
  security_group_id = openstack_networking_secgroup_v2.master.id
}

resource "openstack_networking_secgroup_rule_v2" "spark_master_https_in" {
  direction         = "ingress"
  ethertype         = "IPv4"
  description       = "Allows inbound connections to https server"
  protocol          = "tcp"
  port_range_min    = 443
  port_range_max    = 443
  security_group_id = openstack_networking_secgroup_v2.master.id
}

resource "openstack_networking_secgroup_rule_v2" "spark_master_worker_in" {
  direction         = "ingress"
  ethertype         = "IPv4"
  description       = "Allows inbound connections from any worker node"
  protocol          = "tcp"
  remote_group_id   = openstack_networking_secgroup_v2.worker.id
  security_group_id = openstack_networking_secgroup_v2.master.id
}

output "master" {
  value = openstack_networking_secgroup_v2.master.id
}
