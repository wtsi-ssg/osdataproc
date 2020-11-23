resource "openstack_networking_secgroup_v2" "worker" {
  name = "${var.name}-worker"
}

resource "openstack_networking_secgroup_rule_v2" "spark_worker_master_in" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  remote_group_id   = openstack_networking_secgroup_v2.master.id
  security_group_id = openstack_networking_secgroup_v2.worker.id
}

resource "openstack_networking_secgroup_rule_v2" "spark_worker_worker_in" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  remote_group_id   = openstack_networking_secgroup_v2.worker.id
  security_group_id = openstack_networking_secgroup_v2.worker.id
}

output "worker" {
  value = openstack_networking_secgroup_v2.worker.id
}
