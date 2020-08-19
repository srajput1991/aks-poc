## General
# Define the common tags for all resources.
variable "tags" {
  description = "A map of the tags to use for the resources that are deployed."
  type        = map

  default = {
    tier               = "Infrastructure"
    application        = "aks"
    applicationversion = "1.0.0"
    team               = "devops"
  }
}

# Define prefix for consistent resource naming.
variable "resource_prefix" {
  type        = string
  description = "Service prefix to use for naming of resources."
  default     = "test"
}
