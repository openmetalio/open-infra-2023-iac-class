# Set the required provider
terraform {
required_version = ">= 0.14.0"
  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "~> 1.48.0"
    }
  }
}

# Set the provider to openstack and for this instance, disable TLS verficiation
provider "openstack" {
    insecure = true
}

# Create a network
resource "openstack_networking_network_v2" "oif_workshop_net" {
  name = "oif_workshop_net"
  admin_state_up = "true"
}

# Create and assign a subnet to this network
resource "openstack_networking_subnet_v2" "oif_workshop_subnet" {
  name = "oif_workshop_subnet"
  network_id = openstack_networking_network_v2.oif_workshop_net.id
  cidr = "192.168.1.0/24"
  ip_version = 4
}

# Get the ID of the current public network
data "openstack_networking_network_v2" "external_net" {
  name = "External"
}

# Create router on the public network
resource "openstack_networking_router_v2" "workshop_router" {
  name                = "workshop_router"
  external_network_id = data.openstack_networking_network_v2.external_net.id
}

# Connect the router to the private network
resource "openstack_networking_router_interface_v2" "router_interface" {
  router_id = "${openstack_networking_router_v2.workshop_router.id}"
  subnet_id = "${openstack_networking_subnet_v2.oif_workshop_subnet.id}"
}

# Add your public ssh key 
resource "openstack_compute_keypair_v2" "oif-keypair" {
  name       = "oif-keypair"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCrv5Q3dEVOmzPaXN5ekx1TYS71mBwvtDU+mkaF3LpWTUHrcGTs1dQXS+jGd+cKBwVkjwiUnnLPBDdpVB6iXwy7jlB99XiY4DX3NtueNSSrYSkK+w2W9+MiGbeV7xIw5G/jreWPwUuAiNZiY1nDLA13CvwsfUBVOE7/P8FZ6cHxRgHn3lvd9pZY7SO8KdG+pjLar3Xdky73UVVlkdb6Ue7nsHhzkZkBBBhQvMGxFUVW/C7/9yyI/Ums+p2KQxep60wBslNJZS99s+Zk2vL0t5QuVAWNrLzI1KaCIRjA7ddNpgwTAAirbL99xbdFvLjqUhVehoEQo3dIPZXks/pVuBJz6yBsmCNb4VLzojWGLwka4LG6Ggtcq3RtHxdzyGzNUX19/M0Jrc47qyUGbhYBpaj9Sx/GIvGIHytZko5ZVm4+a2/YfNbWqT57ArgA+XjLqy75xvSKrmtvEX3YaQkAZr78i8hCqIgGY8o1gfW09j+hReGhnnqLQxaiwtt4d7LWD6EhJYOogYX0IYP1wGdocTPI+zR+ird1LaOaHvJAppTaDgutYLxpD2h5QvDOFNI3UJN5FEXSSE373Y4OxftuF797zd95gFPm2WGzG4cigckfO09t5Zv2hHF+G+0CxzVQ9JWznwsJp0JBoFDJltG4kcZxw6tb9VpKZAw8NTBqunEjlw== chrisb"
}

# Create an ubuntu VM, on the private network
resource "openstack_compute_instance_v2" "oif_ubuntu" {
  name = "oif_ubuntu"
  image_name = "Ubuntu 22.04 (Jammy)"
  flavor_name = "gen.small"
  key_pair = "oif-keypair"

  network {
    name = "oif_workshop_net"
  }
}

# Add a floating IP to your project
resource "openstack_networking_floatingip_v2" "oif_ip" {
  pool = "External"
}

# Assign your floating IP to the VM
resource "openstack_compute_floatingip_associate_v2" "oif_ip" {
  floating_ip = "${openstack_networking_floatingip_v2.oif_ip.address}"
  instance_id = "${openstack_compute_instance_v2.oif_ubuntu.id}"
}

# Grab the current default security group
data "openstack_networking_secgroup_v2" "def_group" {
    name = "default"
}

# Open port 22 on the default security group  (Dont do this in production!)
resource "openstack_networking_secgroup_rule_v2" "def_sec_group" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 22
  port_range_max    = 22
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = "${data.openstack_networking_secgroup_v2.def_group.id}"
}