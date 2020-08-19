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
vm_size             = "Standard_DS1_v2"
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
client_app_id = ""
server_app_id = ""
server_app_secret = ""
service_prinicipal_client_id = ""
service_prinicipal_client_secret = ""
tenant_id = ""
