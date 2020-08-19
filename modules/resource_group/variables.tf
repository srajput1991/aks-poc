variable "location" {
  description = "Azure region of the Resource Group"
  type        = string
}


# Define prefix for consistent resource naming.
variable "resource_prefix" {
  type        = string
  default     = "sandbox"
  description = "Service prefix to use for naming of resources."
}

variable "tags"{
  type = string
  default = "stg"
}
