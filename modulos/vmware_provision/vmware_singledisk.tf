resource "vsphere_virtual_machine" "vm" {
  // count = "${var.count}"
  count = "${var.vm_disk2_enable == "false" && var.enable_vm == "true" ? length(var.vm_ipv4_address) : 0}"

  name             = "${var.vm_name[count.index]}"
  folder           = "${var.vm_folder}"
  num_cpus         = "${var.vm_vcpu}"
  memory           = "${var.vm_memory}"
  resource_pool_id = "${data.vsphere_resource_pool.vsphere_resource_pool.id}"
  datastore_id     = "${data.vsphere_datastore.vsphere_datastore.id}"
  guest_id         = "${data.vsphere_virtual_machine.vm_template.guest_id}"
  scsi_type        = "${data.vsphere_virtual_machine.vm_template.scsi_type}"

  clone {
    template_uuid = "${data.vsphere_virtual_machine.vm_template.id}"
    timeout = "${var.vm_clone_timeout}"
    customize {
      linux_options {
        domain    = "${var.vm_domain}"
        host_name = "${var.vm_name[count.index]}"
      }

      network_interface {
        ipv4_address = "${var.vm_ipv4_address[count.index]}"
        ipv4_netmask = "${var.vm_ipv4_prefix_length}"
      }

      ipv4_gateway    = "${var.vm_ipv4_gateway}"
      dns_suffix_list = "${var.vm_dns_suffixes}"
      dns_server_list = "${var.vm_dns_servers}"
    }
  }

  network_interface {
    network_id   = "${data.vsphere_network.vm_network.id}"
    adapter_type = "${var.vm_adapter_type}"
  }

  disk {
    label          = "${var.vm_name[count.index]}.vmdk"
    size           = "${var.vm_disk1_size}"
    keep_on_remove = "${var.vm_disk1_keep_on_remove}"
    datastore_id   = "${data.vsphere_datastore.vsphere_datastore.id}"
  }

  # Specify the connection
  connection {
    type     = "ssh"
    user     = "${var.vm_os_user}"
    password = "${var.vm_os_password}"
    bastion_host        = "${var.bastion_host}"
    bastion_user        = "${var.bastion_user}"
    bastion_private_key = "${ length(var.bastion_private_key) > 0 ? base64decode(var.bastion_private_key) : var.bastion_private_key}"
    bastion_port        = "${var.bastion_port}"
    bastion_host_key    = "${var.bastion_host_key}"
    bastion_password    = "${var.bastion_password}"        
  }

}

resource "null_resource" "vm-create_done" {
  depends_on = ["vsphere_virtual_machine.vm", "vsphere_virtual_machine.vm2disk"]

  provisioner "local-exec" {
    command = "echo 'VM creates done for ${var.vm_name[count.index]}X.'"
  }
}
