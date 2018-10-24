#####################################################################
##
##      Created 10/24/18 by admin. for add_disk
##
#####################################################################

terraform {
  required_version = "> 0.8.0"
}


resource "null_resource" "add_disk_to_vm" {
  provisioner "file" {
    destination = "/tmp/add_disk_to_vm.sh"
    content     = <<EOT
#!/bin/bash
HOST=$1
USER=$2
PWD=$3
VM=$4
SIZE=$5

# add disk to vm
python2.7 ./add_disk_to_vm.py -s $HOST -u $USER -p $PWD -v $VM --disk-size $SIZE
# get device
DEV=`lsblk | tail -n1 | cut -f1 -d " "`
# add to vg
pvcreate $DEV
vgextend vg_root $DEV
EOT
}
  
  provisioner "remote-exec" {
     inline = [
     	  "chmod +x add_disk_to_vm.sh",
        "sudo bash /tmp/add_disk_to_vm.sh ${var.vcenter} ${var.user} ${var.password} ${var.vm_hostname} ${var.disk_size}"
      ]
  }
  connection {
    type = "ssh"
    user = "${var.add_disk_to_vm_connection_user}"
    password = "${var.add_disk_to_vm_connection_password}"
    host = "${var.add_disk_to_vm_connection_host}"
  }
}