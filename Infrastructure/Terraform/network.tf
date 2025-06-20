#vertual network for the cluster1 'snet-{var.aks_node_pool_subnet_name}'| The created vnet need to be pushed to the Aks cluster
module "cluster1_virtual_network" {
    source = "github.com/wso2/azure-terraform-modules//modules/azurerm/Virtual-Network?ref=v0.44.0"
    virtual_network_name            = local.cluster1_virtual_network_name
    virtual_network_address_space   = ["10.1.0.0/16"]
    location                        = var.location
    resource_group_name             = module.resouce_group.resource_group_name
    tags                            = local.tags
}

#vertual network for the cluster1 'snet-{var.aks_node_pool_subnet_name}' | The created vnet need to be pushed to the Aks cluster
module "cluster2_virtual_network" {
    source = "github.com/wso2/azure-terraform-modules//modules/azurerm/Virtual-Network?ref=v0.44.0"
    virtual_network_name            = local.cluster1_virtual_network_name
    virtual_network_address_space   = ["10.1.0.0/16"]
    location                        = var.location
    resource_group_name             = module.resouce_group.resource_group_name
    tags                            = local.tags
}

#Handing peering between two vnets.
module "cluster1_virtual_network_to_cluster2_virtual_network" {
    source                      = "github.com/wso2/azure-terraform-modules//modules/azurerm/Vnet-Peering?ref=v0.44.0"
    custom_peering_dest_name    = "cluster1_virtual_network_to_cluster2_virtual_network"
    resource_group_name         = module.resouce_group.resource_group_name
    virtual_network_name        = module.cluster1_virtual_network.virtual_network_name
    remote_virtual_network_id   = module.cluster2_virtual_network.virtual_network_id
    allow_virtual_network_acces = true
    allow_forwarded_traffic     = true
}


module "cluster2_virtual_network_to_cluster1_virtual_network" {
    source                      = "github.com/wso2/azure-terraform-modules//modules/azurerm/Vnet-Peering?ref=v0.44.0"
    custom_peering_dest_name    = "cluster2_virtual_network_to_cluster1_virtual_network"
    resource_group_name         = module.resouce_group.resource_group_name
    virtual_network_name        = module.cluster2_virtual_network.virtual_network_name
    remote_virtual_network_id   = module.cluster1_virtual_network.virtual_network_id
    allow_virtual_network_acces = true
    allow_forwarded_traffic     = true
}

# If there are exsisting VNets that needs to be peered with the above VNets those also should be handled.

#Creating DNS zone.
#Private DNS Zone for AKS service discovery
module "common_aks_cluster_dns" {
    source                  = "github.com/wso2/azure-terraform-modules//modules/azurerm/Private-DNS-Zone?ref=v0.44.0"
    private_dns_zone_name   = var.private_dns_zone_name
    resource_group_name     = module.resouce_group.resource_group_name
    tags                    = var.tags
}

# Link cluster1_virtual_network to DNS zone
module "cluster1_dns_vnet_link" {
    source                              = "github.com/wso2/azure-terraform-modules//modules/azurerm/Private-DNS-Zone-Vnet-Link?ref=v0.44.0"
    private_dns_zone_vnet_link_name     = "cluster1_virtual_network-dns-link"
    resource_group_name                 = module.resouce_group.resource_group_name
    private_dns_zone_name               = var.private_dns_zone_name
    virtual_network_id                  = module.cluster1_virtual_network.virtual_network_id
    #registration_enabled                = true #not used in module, have to check why?
}

module "cluster2_dns_vnet_link" {
    source                              = "github.com/wso2/azure-terraform-modules//modules/azurerm/Private-DNS-Zone-Vnet-Link?ref=v0.44.0"
    private_dns_zone_vnet_link_name     = "cluster1_virtual_network-dns-link"
    resource_group_name                 = module.resouce_group.resource_group_name
    private_dns_zone_name               = var.private_dns_zone_name
    virtual_network_id                  = module.cluster2_virtual_network.virtual_network_id
    #registration_enabled                = true #not used in module, have to check why?
}

#Assign roles for aks clusters
module "dns_zone_permission_aks_cluster_1" {
    source                  = "github.com/wso2/azure-terraform-modules//modules/azurerm/Role-Assignment?ref=v0.44.0"
    resource_id             = module.common_aks_cluster_dns.private_dns_zone_id
    role_definition_name    = "DNS Zone Contributor"
    principal_id            = module.aks_cluster_1.aks_api_server_identity
}

module "dns_zone_permission_aks_cluster_2" {
    source                  = "github.com/wso2/azure-terraform-modules//modules/azurerm/Role-Assignment?ref=v0.44.0"
    resource_id             = module.common_aks_cluster_dns.private_dns_zone_id
    role_definition_name    = "DNS Zone Contributor"
    principal_id            = module.aks_cluster_2.aks_api_server_identity
}

#Adding DNS A recodes based on the set up in Helm.
module "set_dns_A_records_tm1_DC1" {
    source                  = "github.com/wso2/azure-terraform-modules//modules/azurerm/DNS-A-Record?ref=v0.44.0"
    record_name             = "traffic.manager1.external.svc.dc1"
    zone_name               = var.private_dns_zone_name
    resource_group_name     = module.resouce_group.resource_group_name
    ttl                     = 300
    records                 = ["10.0.1.101"]
    tags                    = local.tags
}
module "set_dns_A_records_tm2_DC1" {
    source                  = "github.com/wso2/azure-terraform-modules//modules/azurerm/DNS-A-Record?ref=v0.44.0"
    record_name             = "traffic.manager2.external.svc.dc1"
    zone_name               = var.private_dns_zone_name
    resource_group_name     = module.resouce_group.resource_group_name
    ttl                     = 300
    records                 = ["10.0.1.102"]
    tags                    = local.tags
}
module "set_dns_A_records_tm1_DC2" {
    source                  = "github.com/wso2/azure-terraform-modules//modules/azurerm/DNS-A-Record?ref=v0.44.0"
    record_name             = "traffic.manager1.external.svc.dc2"
    zone_name               = var.private_dns_zone_name
    resource_group_name     = module.resouce_group.resource_group_name
    ttl                     = 300
    records                 = ["10.0.1.101"]
    tags                    = local.tags
}
module "set_dns_A_records_tm2_DC2" {
    source                  = "github.com/wso2/azure-terraform-modules//modules/azurerm/DNS-A-Record?ref=v0.44.0"
    record_name             = "traffic.manager2.external.svc.dc2"
    zone_name               = var.private_dns_zone_name
    resource_group_name     = module.resouce_group.resource_group_name
    ttl                     = 300
    records                 = ["10.0.1.101"]
    tags                    = local.tags
}
module "set_dns_A_records" {
    source                  = "github.com/wso2/azure-terraform-modules//modules/azurerm/DNS-A-Record?ref=v0.44.0"
    record_name             = "traffic.manager1.external.svc.dc1"
    zone_name               = var.private_dns_zone_name
    resource_group_name     = module.resouce_group.resource_group_name
    ttl                     = 300
    records                 = ["10.0.1.101"]
    tags                    = local.tags
}

              