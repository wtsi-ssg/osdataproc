provider "openstack" {
  version     = "~> 1.24"
  user_name   = var.os_user_name
  tenant_name = var.os_tenant_name
  password    = var.os_password
  auth_url    = var.os_auth_url
}
