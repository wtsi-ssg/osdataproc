resource "openstack_blockstorage_volume_v3" "volume" {
  description = "osdataproc provisioned volume"
  name        = var.nfs_volume
  size        = var.volume_size
}
