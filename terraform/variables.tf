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
  default = 1
}

variable "cluster_name" {}

variable "network_name" {}

variable "image_name" {}

variable "flavor_name" {}

variable "spark_master_public_ip" {
  description = "Floating IP to associate to master node."
  default = ""
}

// TODO update key_pair - user specifies
variable "spark_keypair" {
//  default = "spark_keypair"
}

variable "identity_file" {
  default = ""
}
