resource "openstack_compute_instance_v2" "example_instance" {
  name        = "example-instance"
  flavor_name = "m1.small"
  image_name  = "ubuntu-20.04"
  key_pair    = "my-key"
  network {
    name = "my-network"
  }
}