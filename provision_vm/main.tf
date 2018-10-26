#####################################################################
##
##      Created 10/23/18 by admin. for project2
##
#####################################################################

## REFERENCE {"vsphere_network":{"type": "vsphere_reference_network"}}

terraform {
  required_version = "> 0.8.0"
}

provider "vsphere" {
  allow_unverified_ssl = "${var.allow_unverified_ssl}"
  version = "~> 1.2"
}


data "vsphere_virtual_machine" "virtual_machine_template" {
  name          = "${var.virtual_machine_template_name}"
  datacenter_id = "${data.vsphere_datacenter.virtual_machine_datacenter.id}"
}

data "vsphere_datacenter" "virtual_machine_datacenter" {
  name = "${var.virtual_machine_datacenter_name}"
}

data "vsphere_compute_cluster" "virtual_machine_compute_cluster" {
  name          = "${var.virtual_machine_compute_cluster_name}"
  datacenter_id = "${data.vsphere_datacenter.virtual_machine_datacenter.id}"
}

data "vsphere_datastore" "virtual_machine_datastore" {
  name          = "${var.virtual_machine_datastore_name}"
  datacenter_id = "${data.vsphere_datacenter.virtual_machine_datacenter.id}"
}

data "vsphere_network" "network" {
  name          = "${var.network_network_name}"
  datacenter_id = "${data.vsphere_datacenter.virtual_machine_datacenter.id}"
}

resource "vsphere_virtual_machine" "virtual_machine" {
  name          = "${var.virtual_machine_name}"
  datastore_id  = "${data.vsphere_datastore.virtual_machine_datastore.id}"
  num_cpus      = "${var.virtual_machine_number_of_vcpu}"
  memory        = "${var.virtual_machine_memory}"
  guest_id = "${data.vsphere_virtual_machine.virtual_machine_template.guest_id}"
  resource_pool_id = "${data.vsphere_compute_cluster.virtual_machine_compute_cluster.resource_pool_id}"
  
  network_interface {
    network_id = "${data.vsphere_network.network.id}"
  }
  clone {
    template_uuid = "${data.vsphere_virtual_machine.virtual_machine_template.id}"
    customize {
      linux_options {
        domain    = "redsys.lab"
        host_name = "${var.virtual_machine_name}"
      }

      network_interface {
        ipv4_address = "${var.vm_ipv4_address}"
        ipv4_netmask = "24"
      }

      ipv4_gateway    = "10.129.254.1"
      dns_suffix_list = ["redsys.lab"]
      dns_server_list = ["10.129.254.6"]
    }
  }
  disk {
    label = "${var.virtual_machine_disk_name}"
    size = "${var.virtual_machine_disk_size}"
  }
}