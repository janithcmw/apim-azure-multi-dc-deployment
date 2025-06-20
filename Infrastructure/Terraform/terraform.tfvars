# Cluster Configurations
# Common Configurations.
project          = "multi-dc"
application_name = "cst"
environment      = "env"
location         = "westeurope"
hub_spoke        = "spoke"

//AKS Cluster 
kubernetes_version      = "1.29.9"
private_cluster_enabled = true

#Node Pool
default_node_pool_name                 = "akspool"
default_node_pool_vm_size              = "Standard_D8ds_v5"
default_node_pool_os_disk_size_gb      = 128
default_node_pool_max_count            = 6
default_node_pool_min_count            = 3
default_node_pool_count                = 3
default_node_pool_max_pods             = 30
default_node_pool_orchestrator_version = "1.29"

#Network Profile
outbound_type = "loadBalancer"

#Profile
aks_public_ssh_key_path = "./ssh/id_rsa.pub"
aks_admin_username      = "ubuntu"

# NSG rules for cluster subnet and Load balancer subnet
aks_node_pool_subnet_nsg_rules = {
#  allow_vm_subnet_to_nodepool = {#todo need to check for the outbunt traffic
#    priority                                   = "100"
#    name                                       = "AllowVmSubnetToNodepool"
#    description                                = "Allow traffic from VM's subnet to AKS node pool"
#    direction                                  = "Inbound"
#    access                                     = "Allow"
#    protocol                                   = "*"
#    source_port_ranges                         = ["0-65535"]
#    destination_port_ranges                    = ["0-65535"]
#    source_address_prefixes                    = ["*"]
#    destination_address_prefixes               = ["*"]
#    source_application_security_group_ids      = []
#    destination_application_security_group_ids = []
#  }
  # allow_nodepool_outbound_to_any = {
  # priority                                   = "200"
  # name                                       = "AllowNodepoolOutboundToAny"
  # description                                = "Allow AKS node pool to send outbound traffic to any"
  # direction                                  = "Outbound"
  # access                                     = "Allow"
  # protocol                                   = "*"
  # source_port_ranges                         = ["0-65535"]
  # destination_port_ranges                    = ["0-65535"]
  # source_address_prefixes                    = ["*"]   # or specific nodepool subnet like ["10.0.1.0/24"]
  # destination_address_prefixes               = ["*"]   # or e.g., ["10.0.5.0/24"] for DB
  # source_application_security_group_ids      = []
  # destination_application_security_group_ids = []
  # }
}

aks_load_balancer_subnet_nsg_rules = {
#  allow_vm_subnet_to_loadbalancer = {
#    priority                                   = "120"
#    name                                       = "AllowVmSubnetToLoadBalancer"
#    description                                = "Allow traffic from VM's subnet to AKS load balancer"
#    direction                                  = "Inbound"
#    access                                     = "Allow"
#    protocol                                   = "*"
#    source_port_ranges                         = ["0-65535"]
#    destination_port_ranges                    = ["0-65535"]
#    source_address_prefixes                    = ["*"]
#    destination_address_prefixes               = ["*"]
#    source_application_security_group_ids      = []
#    destination_application_security_group_ids = []
#  }
  # allow_loadbalancer_outbound_to_any = {
  # priority                                   = "220"
  # name                                       = "AllowNodepoolOutboundToAny"
  # description                                = "Allow AKS node pool to send outbound traffic to any"
  # direction                                  = "Outbound"
  # access                                     = "Allow"
  # protocol                                   = "*"
  # source_port_ranges                         = ["0-65535"]
  # destination_port_ranges                    = ["0-65535"]
  # source_address_prefixes                    = ["*"]   # or specific nodepool subnet like ["10.0.1.0/24"]
  # destination_address_prefixes               = ["*"]   # or e.g., ["10.0.5.0/24"] for DB
  # source_application_security_group_ids      = []
  # destination_application_security_group_ids = []
  # }
}

# Network Profile
cluster1_service_cidr   = "10.200.0.0/24"
cluster1_dns_service_ip = "10.200.0.10"

cluster2_service_cidr   = "10.201.0.0/24"
cluster2_dns_service_ip = "10.201.0.10"

# Aks node pool
cluster1_aks_node_pool_subnet_address_prefix = "10.1.1.0/24"
cluster2_aks_node_pool_subnet_address_prefix = "10.2.1.0/24"


# Load balancer configuration
cluster1_internal_loadbalancer_subnet_address_prefix = "10.3.1.0/24"
cluster2_internal_loadbalancer_subnet_address_prefix = "10.4.1.0/24"
