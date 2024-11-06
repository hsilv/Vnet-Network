variable "vm_count_ventas" {
  description = "Number of VMs to create in ventas"
  type        = number
  default     = 1
}

variable "vm_count_ti" {
  description = "Number of VMs to create in ti"
  type        = number
  default     = 1
}

variable "vm_count_datacenter" {
  description = "Number of VMs to create in datacenter"
  type        = number
  default     = 1
}

variable "vm_count_visitors" {
  description = "Number of VMs to create in visitors"
  type        = number
  default     = 1
}

variable "admin_username" {
  description = "Admin username for the VMs"
  type        = string
  default     = "adminuser"
}

variable "admin_password" {
  description = "Admin password for the VMs"
  type        = string
  default     = "P@ssw0rd1234!"
}