#########################
# Input Variables       #
#########################

variable "admin_username" {
  description = "Admin Username for Virtual Machines"
}

variable "admin_password" {
  description = "Admin Password for Virtual Machines"
}

variable "resource_group_name" {
  description = ""
}

variable "resource_group_location" {
  description = ""
}

variable "vnet_subnet_id" {
  description = ""
}

variable "base_index" {
  description = "Base index"
  default = 0
}

variable "protools_vm_hostname" {
  description = "description"
}

variable "protools_vm_size" {
  description = "description"
}

variable "protools_nb_instances" {
  description = "description"
}

variable "ProToolsScriptURL" {
    type = string 
}

variable "ProToolsURL" {
    type = string 
}

variable "protools_internet_access" {
    type = bool 
}

variable "NvidiaURL" {
    type = string 
}

variable "TeradiciKey" {
    type = string 
}

variable "TeradiciURL" {
    type = string 
}

variable "AvidNexisInstallerUrl" {
    type = string 
}
