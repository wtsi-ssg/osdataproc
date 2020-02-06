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

variable "image_name" {
  default = "bionic-server"
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
