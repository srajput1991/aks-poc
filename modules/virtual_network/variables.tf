variable "resource_group_name" {
  description = "Name of the Virtual Network resource group"
  type        = string
}

variable "resource_prefix" {
  type        = string
  description = "Service prefix to use for naming of resources."
}

variable "location" {
  description = "Azure region of the Virtual Network"
  type        = string
}

variable "vnet_address_space" {
  description = "The address space (CIDR notation) of the Virtual Network"
  type        = list(string)
}


variable "tags"{
  type = string
  default = "stg"
}
