variable "workers" {
  default = 2
}

variable "network_name" {
  default = "cloudforms_network"
}

variable "lustre_network" {
  default = ""
}

variable "image_name" {
  default = "bionic-server"
}

variable "flavor_name" {
  default = "m2.medium"
}

variable "nfs_volume" {
  description = "The ID of a volume to mount to a cluster"
  default     = ""
}

variable "spark_master_public_ip" {
  description = "Floating IP to associate to master node"
  default     = ""
}

variable "username" {
  description = "Username for the tenant/cluster"
}

variable "cluster_name" {
  description = "Name for the cluster"
}

variable "identity_file" {
  default     = ""
  description = "SSH public key"
}

variable "netdata_api_key" {
  description = "Netdata API key"
}

locals {
  name_prefix = "${var.username}-${var.cluster_name}"
}
