# Define prefix for consistent resource naming.
variable "resource_prefix" {
  type        = string
  description = "Service prefix to use for naming of resources."
}
variable "container_registry_id" {
  description = "Resource id of the ACR"
  type        = string
}

variable "tags"{
  type = string
  default = "stg"
}
# Define Azure region for resource placement.
variable "location" {
  type        = string
  description = "Azure region for deployment of resources."
}

# Define username for use on the hosts.
variable "username" {
  type        = string
  description = "Username to build and use on the VM hosts."
}

# Define vnet cidr.
variable "vnet_address_space" {
  type        = list(string)
  description = "Cidr for the Azure vnet"
}

# Define node count of node Pool.
variable "nodecount" {
  type        = string
  description = "No of VM required as Kubernetes Worker."
}

# Define Virtual Machine size.
variable "vm_size" {
  type        = string
  description = "Virtual Machine Size."
}

# Define Enable Autoscalling for Node Pool.
variable "enable_auto_scaling" {
  type        = string
  description = "Enable Autoscalling for Node Pool."
}

# Define Disk size of Worker Node.
variable "os_disk_size_gb" {
  type        = string
  description = "Disk size of Worker Node."
}

# Define SSH key to access the worker Node.
#variable "ssh_key" {
#  type        = string
#  description = "SSH key to access the worker Node."
#}

# Define Kubernetes Version.
variable "kubernetes_version" {
  type        = string
  description = "Kubernetes Version."
}

# Define dns name for hosted zone
variable "dnszone_name" {
  type        = string
  description = "Domain name for hosted Zone."
}


# Define ssh_key to access the Worker Node.
variable "ssh_key_path" {
  description = "Public key to access the VMs"
}

# Define ssh_key location from where to copy.
variable "key_data" {
  description = "Public key from where to copy inside the provisoned  VMs"
}

# Define password to access the bastion hosts.
variable "admin_password" {
  type        = string
  description = "Password to acess the bastion hosts."
}


# Define allowded IP address to access the bastion nodes and kubernetes cluster.
variable "allowed_ipaddress" {
  type        = list(string)
  description = "Define ip addess to access kubernetes cluster and bastion hosts"
}

variable "aad_group_name" {
  description = "Name of the Azure AD group for cluster-admin access"
  type        = string
}

# aks
variable "default_node_pool" {
  description = "The object to configure the default node pool with number of worker nodes, worker node VM size and Availability Zones."
  type = object({
    name                           = string
    node_count                     = number
    vm_size                        = string
    zones                          = list(string)
    labels                         = map(string)
    taints                         = list(string)
    cluster_auto_scaling           = bool
    cluster_auto_scaling_min_count = number
    cluster_auto_scaling_max_count = number
  })
}

variable "additional_node_pools" {
  description = "The map object to configure one or several additional node pools with number of worker nodes, worker node VM size and Availability Zones."
  type = map(object({
    name                           = string
    node_count                     = number
    vm_size                        = string
    zones                          = list(string)
    labels                         = map(string)
    taints                         = list(string)
    node_os                        = string
    cluster_auto_scaling           = bool
    cluster_auto_scaling_min_count = number
    cluster_auto_scaling_max_count = number
  }))
}


variable "addons" {
  description = "Defines which addons will be activated."
  type = object({
    oms_agent            = bool
    kubernetes_dashboard = bool
    azure_policy         = bool
  })
}
