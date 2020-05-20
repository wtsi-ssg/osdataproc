resource "openstack_blockstorage_volume_v3" "volume" {
  description = "osdataproc provisioned volume"
  name        = var.volume_name
  size        = var.volume_size
}
