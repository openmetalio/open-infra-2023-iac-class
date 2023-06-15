terraform {
required_version = ">= 0.14.0"
  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "~> 1.48.0"
    }
  }
}

provider "openstack" {
    cloud = "oif-workshop"
    insecure = true
}

resource "openstack_networking_network_v2" "example_network" {
  name        = "open_infra_2023"
  admin_state_up = true
}