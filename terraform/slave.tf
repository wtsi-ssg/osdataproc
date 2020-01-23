resource "openstack_networking_secgroup_v2" "spark_slave" {
  name = "${var.os_user_name}_${var.cluster_name}_slaves_secgroup"
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
  name            = format("${var.os_user_name}_${var.cluster_name}_slave_%02d",count.index+1)
  count           = var.slaves
  image_name      = var.image_name
  flavor_name     = var.slave_flavor_name
  key_pair        = var.spark_keypair == "None" ? openstack_compute_keypair_v2.spark_keypair[0].id : var.spark_keypair
  security_groups = [openstack_networking_secgroup_v2.spark_slave.id]
  user_data       = file("setup.sh")

  network {
    name = "cloudforms_network"
  }

  provisioner "local-exec" {
    command = "echo '[spark_slaves]\nubuntu@${self.access_ip_v4}' >> terraform.tfstate.d/${var.cluster_name}/hosts_slaves"
  }
}
