resource "openstack_networking_network_v2" "oif_workshop_net" {
  name = "oif_workshop_net"
  admin_state_up = "true"
}

resource "openstack_networking_subnet_v2" "oif_workshop_subnet" {
  name = "oif_workshop_subnet"
  network_id = openstack_networking_network_v2.oif_workshop_net.id
  cidr = "192.168.1.0/24"
  ip_version = 4
}