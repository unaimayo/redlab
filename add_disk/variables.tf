#####################################################################
##
##      Created 10/24/18 by admin. for add_disk
##
#####################################################################

variable "vcenter_host" {
  type = "string"
  description = "vCenter hostname"
}
 
variable "vcenter_user" {
  type = "string"
  description = "vCenter user"
}
 
variable "vcenter_password" {
  type = "string"
  description = "vCenter password"
}
 
variable "template_user" {
  type = "string"
  description = "VMware template user"
}
 
variable "template_password" {
  type = "string"
  description = "VMware template password"
}
 
variable "vm_hostname" {
  type = "string"
  description = "vCenter password"
}

variable "disk_size" {
  type = "string"
  description = "vCenter password"
}

variable "add_disk_to_vm_connection_user" {
  type = "string"
  default = "root"
}

variable "add_disk_to_vm_connection_password" {
  type = "string"
}

variable "add_disk_to_vm_connection_host" {
  type = "string"
}
  