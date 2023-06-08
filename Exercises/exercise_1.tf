# Dont worry about this part for now!
provider "openstack" {
}

resource "openstack_networking_network_v2" "example_network" {
  name        = "open_infra_2023"
  admin_state_up = true
}