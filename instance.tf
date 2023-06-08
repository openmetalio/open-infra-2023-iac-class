provider "openstack" {}

resource "openstack_compute_instance_v2" "oif_ubuntu" {
  name = "oif_ubuntu"
  image_name = "Ubuntu 22.04 (Jammy)"
  flavor_name = "gen.small"
  key_pair = "my_keypair"

  network {
    name = "oif_workshop_net"
  }
}