variable "os_user_name" {
  description = "The username for the tenant."
}

variable "os_tenant_name" {
  description = "The name of the tenant."
}

variable "os_password" {
  description = "The password of the user."
}

variable "os_auth_url" {
  description = "The endpoint url to connect to OpenStack."
}

variable "os_interface" {}

variable "slaves" {
  default = 2
}

variable "cluster_name" {}

variable "network_name" {
  default = "cloudforms_network"
}

variable "network_id" {
  default = "03bccdae-535f-4d95-8dc6-445309c28320"
}

variable "lustre_net" {
  default = "eeded367-662a-4d39-8319-216bce127393"
}

variable "image_name" {
  default = "bionic-WTSI-lustre-2_12_3_docker_20200211_4016b2"
}

variable "flavor_name" {
  default = "m1.medium"
}

variable "spark_master_public_ip" {
  description = "Floating IP to associate to master node."
  default = ""
}

variable "identity_file" {
  default = ""
}

variable "netdata_api_key" {}

variable "nfs_volume_id" {}
