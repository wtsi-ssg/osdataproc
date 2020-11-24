variable "identifier" {
  type        = string
  description = "Identifier prefix"
}

variable "workers" {
  type        = number
  description = "Number of worker nodes"
}

variable "network_name" {
  type        = string
  description = "Main network"
}

variable "lustre_network" {
  type        = string
  description = "Lustre provider network"
  default     = ""
}

variable "floating_ip" {
  type        = string
  description = "Floating IP for the master node"
  default     = ""
}

variable "security_groups" {
  type        = object({master = string, worker = string})
  description = "Security groups for master and worker nodes"
}

locals {
  create_ip   = var.floating_ip == ""
  with_lustre = var.lustre_network != ""
}
