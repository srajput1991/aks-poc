module resource_group {
  source = "./modules/resource_group"
  resource_prefix    = var.resource_prefix
  location  = var.location
  tags = var.tags
}

# Create a vnet
module network {
  source = "./modules/virtual_network"
  resource_prefix = var.resource_prefix
  location = var.location
  resource_group_name = module.resource_group.name
  vnet_address_space = var.vnet_address_space
  tags = var.tags
}

# Create a aks cluster
module kubernetes {
  source                   = "./modules/aks"
  aad_group_name           = var.aad_group_name
  resource_prefix          = var.resource_prefix
  location                 = var.location
  resource_group_name      = module.resource_group.name
  kubernetes_version       = var.kubernetes_version
  private_cluster          = false
  allowed_ipaddress        = var.allowed_ipaddress
  vnet_subnet_id           = module.virtual_network.subnet_id

  default_node_pool = {
    name                           = "nodepool1"
    node_count                     = 3
    vm_size                        = var.vm_size
    zones                          = ["1", "2", "3"]
    taints                         = null
    cluster_auto_scaling           = false
    cluster_auto_scaling_min_count = null
    cluster_auto_scaling_max_count = null
    labels = {
      "environment" = "demo"
    }
  }

  addons = {
    oms_agent            = false
    kubernetes_dashboard = false
    azure_policy         = false
  }


}
