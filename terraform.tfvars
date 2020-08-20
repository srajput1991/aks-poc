#####################################
## Network Environment Variables ####
#####################################
location           = "centralus"
resource_prefix    = "sandbox"
username           = "terraform"
vnet_address_space = ["10.0.0.0/16"]
admin_password     = "Passw0rd123"
allowed_ipaddress  = ["0.0.0.0/0"]
#allowed_ipaddress  = ["182.69.251.11/32"]
#####################################
## K8S Environment Variables ########
#####################################
nodecount           = 1
vm_size             = "Standard_D2_v2"
enable_auto_scaling = false
os_disk_size_gb     = 100
ssh_key_path        = "/home/terraform/.ssh/authorized_keys"
key_data            = "/home/terraform/.ssh/id_rsa.pub"
kubernetes_version  = "1.15.12"
aad_group_name      = "myAKSAdminGroup"
#####################################
## DNS Environment Variables ########
#####################################
dnszone_name = ""
#####################################
## AD Environment Variables ########
#####################################
addons={
  oms_agent=false
  kubernetes_dashboard=false
  azure_policy=false
}

default_node_pool={
  name="nodepool1"
  node_count=1
  vm_size="Standard_D2_v2"
  zones=["1","2"]
  labels={
    "environment" = "demo"
  }
  taints = null
  cluster_auto_scaling = true
  cluster_auto_scaling_min_count=1
  cluster_auto_scaling_max_count=2
}

additional_node_pools={
  nodepool2={
    node_count = 1
    name = "nodepool2"
    vm_size = "Standard_DS1_v2"
    zones = ["1","2"]
    labels={
      "environment" = "demo"
    }
    taints = null
    node_os = "Linux"
    cluster_auto_scaling = true
    cluster_auto_scaling_min_count = 1
    cluster_auto_scaling_max_count = 2
  }
}

container_registry_id="/subscriptions/01a44637-0c14-411e-8e31-b1d5c14727eb/resourceGroups/acr-rg/providers/Microsoft.ContainerRegistry/registries/sachin"
