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
  vnet_subnet_id           = module.network.subnet_id
  container_registry_id    = var.container_registry_id

  addons={
    oms_agent=var.addons.oms_agent
    kubernetes_dashboard=var.addons.kubernetes_dashboard
    azure_policy=var.addons.azure_policy
  }

  default_node_pool = {
    name = var.default_node_pool.name
    node_count = var.default_node_pool.node_count
    vm_size = var.default_node_pool.vm_size
    zones = var.default_node_pool.zones
    labels = var.default_node_pool.labels
    taints = var.default_node_pool.taints
    cluster_auto_scaling   = var.default_node_pool.cluster_auto_scaling
    cluster_auto_scaling_min_count             = var.default_node_pool.cluster_auto_scaling_min_count
    cluster_auto_scaling_max_count             = var.default_node_pool.cluster_auto_scaling_max_count
  }

  additional_node_pools={
    nodepool1={
      node_count = 3
      vm_size = "Standard_DS1_v2"
      zones = ["1","2"]
      labels={
        "environment" = "demo"
      }
      taints = null
      node_os = "Linux"
      cluster_auto_scaling = true
      cluster_auto_scaling_min_count = 3
      cluster_auto_scaling_max_count = 5
    }

}
}
