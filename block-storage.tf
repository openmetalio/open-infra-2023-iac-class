resource "openstack_blockstorage_volume_v3" "oif_volume_1" {
  name = "oif_volume_1"
  size = 10
  description = "A block storage volume"
}

resource "openstack_compute_volume_attach_v2" "oif_va_1" {
  volume_id = openstack_blockstorage_volume_v3.oif_volume_1.id
  instance_id = openstack_compute_instance_v2.oif_ubuntu.id
}