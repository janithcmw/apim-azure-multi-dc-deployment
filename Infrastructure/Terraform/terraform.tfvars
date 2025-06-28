# Cluster Configurations
# Common Configurations.
project          = "test"
application_name = "cst"
environment      = "multi-dc"
location         = "westeurope"
hub_spoke        = "spoke"

//AKS Cluster 
kubernetes_version      = "1.31.8"
private_cluster_enabled = true

#Node Pool
default_node_pool_name                 = "pl"
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
cluster1_aks_node_pool_subnet_nsg_rules = {
  allow_inbound_from_virtual-network = { # added to allow communication from vnet.
    priority                                   = "100"
    name                                       = "AllowInboundFromVnetsToCluster1PoolSnetVnet"
    description                                = "Allow inbound traffic from all peered VNets"
    direction                                  = "Inbound"
    access                                     = "Allow"
    protocol                                   = "*"
    source_port_ranges                         = ["0-65535"]
    destination_port_ranges                    = ["0-65535"]
    source_address_prefixes                    = ["10.9.0.0/16", "10.2.0.0/16"] # aks2 vnet and shared vnet
    destination_address_prefixes               = ["10.8.0.0/16"]
    source_application_security_group_ids      = []
    destination_application_security_group_ids = []
  }
  allow_outbound_to_other_virtual-network = {  # added to allow communication from vnet.
    priority                                   = "200"
    name                                       = "AllowOutboundFromCluster1PoolSnetVnetToOtherVnets"
    description                                = "Allow inbound traffic from all peered VNets"
    direction                                  = "Inbound"
    access                                     = "Allow"
    protocol                                   = "*"
    source_port_ranges                         = ["0-65535"]
    destination_port_ranges                    = ["0-65535"]
    source_address_prefixes                    = ["10.8.0.0/16"] # aks2 vnet and shared vnet
    destination_address_prefixes               = ["10.9.0.0/16", "10.2.0.0/16"]
    source_application_security_group_ids      = []
    destination_application_security_group_ids = []
  }
}

cluster1_aks_load_balancer_subnet_nsg_rules = {
  allow_inbound_from_other_virtual-network = {  # added to allow communication from vnet.
    priority                                   = "100"
    name                                       = "AllowInboundFromVnetsToCluster1LBSubnetVnet"
    description                                = "Allow inbound traffic from all peered VNets"
    direction                                  = "Inbound"
    access                                     = "Allow"
    protocol                                   = "*"
    source_port_ranges                         = ["0-65535"]
    destination_port_ranges                    = ["0-65535"]
    source_address_prefixes                    = ["10.9.0.0/16", "10.2.0.0/16"] # aks2 vnet and shared vnet
    destination_address_prefixes               = ["10.8.0.0/16"]
    source_application_security_group_ids      = []
    destination_application_security_group_ids = []
  }
  allow_outbound_to_other_virtual-network = {  # added to allow communication from vnet.
    priority                                   = "200"
    name                                       = "AllowOutboundFromCluster1LBSnetVnetToOtherVnets"
    description                                = "Allow inbound traffic from all peered VNets"
    direction                                  = "Inbound"
    access                                     = "Allow"
    protocol                                   = "*"
    source_port_ranges                         = ["0-65535"]
    destination_port_ranges                    = ["0-65535"]
    source_address_prefixes                    = ["10.8.0.0/16"] # aks2 vnet and shared vnet
    destination_address_prefixes               = ["10.9.0.0/16", "10.2.0.0/16"]
    source_application_security_group_ids      = []
    destination_application_security_group_ids = []
  }
}

# NSG rules for cluster subnet and Load balancer subnet
cluster2_aks_node_pool_subnet_nsg_rules = {
  allow_inbound_from_other_virtual-network = { # added to allow communication from vnet.
    priority                                   = "100"
    name                                       = "AllowInboundFromVnetsToCluster2PoolSnetVnet"
    description                                = "Allow inbound traffic from all peered VNets"
    direction                                  = "Inbound"
    access                                     = "Allow"
    protocol                                   = "*"
    source_port_ranges                         = ["0-65535"]
    destination_port_ranges                    = ["0-65535"]
    source_address_prefixes                    = ["10.8.0.0/16", "10.2.0.0/16"] # aks1 vnet and shared vnet
    destination_address_prefixes               = ["10.9.0.0/16"]
    source_application_security_group_ids      = []
    destination_application_security_group_ids = []
  }
  allow_outbound_to_other_virtual-network = {  # added to allow communication from vnet.
    priority                                   = "100"
    name                                       = "AllowOutboundFromCluster2PoolSnetVnetToOtherVnets"
    description                                = "Allow inbound traffic from all peered VNets"
    direction                                  = "Inbound"
    access                                     = "Allow"
    protocol                                   = "*"
    source_port_ranges                         = ["0-65535"]
    destination_port_ranges                    = ["0-65535"]
    source_address_prefixes                    = ["10.9.0.0/16"]
    destination_address_prefixes               = ["10.8.0.0/16", "10.2.0.0/16"]
    source_application_security_group_ids      = []
    destination_application_security_group_ids = []
  }
}

cluster2_aks_load_balancer_subnet_nsg_rules = {
  allow_inbound_from_other_virtual-network = {  # added to allow communication from vnet.
    priority                                   = "100"
    name                                       = "AllowInboundFromOtherVnetsToCluster2LBSnetVnet"
    description                                = "Allow inbound traffic from all peered VNets"
    direction                                  = "Inbound"
    access                                     = "Allow"
    protocol                                   = "*"
    source_port_ranges                         = ["0-65535"]
    destination_port_ranges                    = ["0-65535"]
    source_address_prefixes                    = ["10.8.0.0/16", "10.2.0.0/16"] # aks1 vnet and shared vnet
    destination_address_prefixes               = ["10.9.0.0/16"]
    source_application_security_group_ids      = []
    destination_application_security_group_ids = []
  }
  allow_outbound_to_other_virtual-network = {  # added to allow communication from vnet.
    priority                                   = "200"
    name                                       = "AllowOutboundFromCluster2LBSnetVentToOtherVnets"
    description                                = "Allow inbound traffic from all peered VNets"
    direction                                  = "Inbound"
    access                                     = "Allow"
    protocol                                   = "*"
    source_port_ranges                         = ["0-65535"]
    destination_port_ranges                    = ["0-65535"]
    source_address_prefixes                    = ["10.9.0.0/16"]
    destination_address_prefixes               = ["10.8.0.0/16", "10.2.0.0/16"]
    source_application_security_group_ids      = []
    destination_application_security_group_ids = []
  }
}

# Network Profile
cluster1_service_cidr   = "10.200.0.0/24"
cluster1_dns_service_ip = "10.200.0.10"

cluster2_service_cidr   = "10.201.0.0/24"
cluster2_dns_service_ip = "10.201.0.10"

# Aks node pool
cluster1_aks_node_pool_subnet_address_prefix = "10.8.1.0/24"
cluster2_aks_node_pool_subnet_address_prefix = "10.9.1.0/24"


# Load balancer configuration
cluster1_internal_loadbalancer_subnet_address_prefix = "10.8.0.0/24"
cluster2_internal_loadbalancer_subnet_address_prefix = "10.9.0.0/24"
