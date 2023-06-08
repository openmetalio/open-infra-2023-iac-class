resource "openstack_networking_floatingip_v2" "oif_fip" {
  pool = "External"
}

resource "openstack_compute_floatingip_associate_v2" "oif_fip_1" {
  floating_ip = openstack_networking_floatingip_v2.oif_fip.address
  instance_id = openstack_compute_instance_v2.oif_ubuntu.id
}