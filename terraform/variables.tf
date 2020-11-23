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
  default = "m1.medium"
}

variable "nfs_volume" {
  description = "The ID of a volume to mount to a cluster"
  default = ""
}

variable "spark_master_public_ip" {
  description = "Floating IP to associate to master node."
  default = ""
}

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

variable "cluster_name" {}

variable "identity_file" {
  default = ""
}

variable "netdata_api_key" {}
