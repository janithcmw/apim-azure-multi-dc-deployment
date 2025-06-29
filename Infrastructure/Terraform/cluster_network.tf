# Handle the current cluster network.
#vertual network for the cluster1 'snet-{var.aks_node_pool_subnet_name}'| The created vnet need to be pushed to the Aks cluster
module "cluster1_virtual_network" {
    source = "github.com/wso2/azure-terraform-modules//modules/azurerm/Virtual-Network?ref=v0.44.0"
    virtual_network_name            = local.cluster1_virtual_network_name
    virtual_network_address_space   = "10.8.0.0/16"
    location                        = var.location
    resource_group_name             = module.resource_group.resource_group_name
    tags                            = local.tags
}

#vertual network for the cluster1 'snet-{var.aks_node_pool_subnet_name}' | The created vnet need to be pushed to the Aks cluster
module "cluster2_virtual_network" {
    source = "github.com/wso2/azure-terraform-modules//modules/azurerm/Virtual-Network?ref=v0.44.0"
    virtual_network_name            = local.cluster2_virtual_network_name
    virtual_network_address_space   = "10.9.0.0/16"
    location                        = var.location
    resource_group_name             = module.resource_group.resource_group_name
    tags                            = local.tags
}

#Handing peering between two vnets.
module "cluster1_virtual_network_to_cluster2_virtual_network" {
    source                              = "github.com/wso2/azure-terraform-modules//modules/azurerm/Vnet-Peering?ref=v0.44.0"
    custom_peering_dest_name            = "cluster1_virtual_network_to_cluster2_virtual_network"
    vnet_src_id                         = module.cluster1_virtual_network.virtual_network_id
    vnet_dest_id                        = module.cluster2_virtual_network.virtual_network_id
    allow_virtual_src_network_access    = true
    allow_forwarded_src_traffic         = true
    depends_on = [
        module.cluster1_virtual_network,
        module.cluster2_virtual_network
    ]
}


module "cluster2_virtual_network_to_cluster1_virtual_network" {
    source                              = "github.com/wso2/azure-terraform-modules//modules/azurerm/Vnet-Peering?ref=v0.44.0"
    custom_peering_dest_name            = "cluster2_virtual_network_to_cluster1_virtual_network"
    vnet_src_id                         = module.cluster2_virtual_network.virtual_network_id
    vnet_dest_id                        = module.cluster1_virtual_network.virtual_network_id
    allow_virtual_src_network_access    = true
    allow_forwarded_src_traffic         = true
    depends_on = [
        module.cluster1_virtual_network,
        module.cluster2_virtual_network
    ]
}

# If there are existing VNets that needs to be peered with the above VNets those also should be handled.

#Creating DNS zone.
#Private DNS Zone for AKS service discovery
module "common_aks_cluster_dns" {
    source                  = "github.com/wso2/azure-terraform-modules//modules/azurerm/Private-DNS-Zone?ref=v0.44.0"
    private_dns_zone_name   = var.private_dns_zone_name
    resource_group_name     = module.resource_group.resource_group_name
    tags                    = var.tags
}

# Link cluster1_virtual_network to DNS zone
module "common_cluster_dns_cluster1_vnet_link" {
    source                              = "github.com/wso2/azure-terraform-modules//modules/azurerm/Private-DNS-Zone-Vnet-Link?ref=v0.44.0"
    private_dns_zone_vnet_link_name     = "cluster1_virtual_network-dns-link"
    resource_group_name                 = module.resource_group.resource_group_name
    private_dns_zone_name               = var.private_dns_zone_name
    virtual_network_id                  = module.cluster1_virtual_network.virtual_network_id
    #registration_enabled                = true #not used in module, have to check why?
    depends_on = [
        module.common_aks_cluster_dns
    ]
}

module "common_cluster_dns_cluster2_vnet_link" {
    source                              = "github.com/wso2/azure-terraform-modules//modules/azurerm/Private-DNS-Zone-Vnet-Link?ref=v0.44.0"
    private_dns_zone_vnet_link_name     = "cluster2_virtual_network-dns-link"
    resource_group_name                 = module.resource_group.resource_group_name
    private_dns_zone_name               = var.private_dns_zone_name
    virtual_network_id                  = module.cluster2_virtual_network.virtual_network_id
    #registration_enabled                = true #not used in module, have to check why?
    depends_on = [
        module.common_aks_cluster_dns
    ]
}

#Assign roles for aks clusters
module "dns_zone_permission_aks_cluster_1" {
    source                  = "github.com/wso2/azure-terraform-modules//modules/azurerm/Role-Assignment?ref=v0.44.0"
    resource_id             = module.common_aks_cluster_dns.private_dns_zone_id
    role_definition_name    = "DNS Zone Contributor"
    principal_id            = module.aks_cluster_1.aks_api_server_identity
    depends_on = [
        module.common_aks_cluster_dns,
        module.common_cluster_dns_cluster1_vnet_link
    ]
}

module "dns_zone_permission_aks_cluster_2" {
    source                  = "github.com/wso2/azure-terraform-modules//modules/azurerm/Role-Assignment?ref=v0.44.0"
    resource_id             = module.common_aks_cluster_dns.private_dns_zone_id
    role_definition_name    = "DNS Zone Contributor"
    principal_id            = module.aks_cluster_2.aks_api_server_identity
    depends_on = [
        module.common_aks_cluster_dns,
        module.common_cluster_dns_cluster2_vnet_link
    ]
}

#Add subnet for point to point communication services
module "cluster1_external_service_subnet" {
    source                      = "github.com/wso2/azure-terraform-modules//modules/azurerm/Subnet?ref=v2.1.0"
    subnet_name                 = var.cluster1_external_service_subnet
    resource_group_name         = module.resource_group.resource_group_name
    location                    = var.location
    virtual_network_name        = module.cluster1_virtual_network.virtual_network_name
    address_prefix              = ["10.8.4.0/24"]
    network_security_group_name = join("-", ["nodepool", var.project, var.application_name, var.environment, var.location, var.cluster1_padding])
    tags                        = local.tags
    depends_on = [
        module.aks_cluster_1
    ]
}

#Add subnet for point to point communication services
module "cluster2_external_service_subnet" {
    source                      = "github.com/wso2/azure-terraform-modules//modules/azurerm/Subnet?ref=v2.1.0"
    subnet_name                 = var.cluster2_external_service_subnet
    resource_group_name         = module.resource_group.resource_group_name
    location                    = var.location
    virtual_network_name        = module.cluster2_virtual_network.virtual_network_name
    address_prefix              = ["10.9.4.0/24"]
    network_security_group_name = join("-", ["nodepool", var.project, var.application_name, var.environment, var.location, var.cluster2_padding])
    tags                        = local.tags
    depends_on = [
        module.aks_cluster_2
    ]
}

#Adding DNS A recodes based on the set up in Helm.
module "set_pvt_dns_A_records_tm1_DC1" {
    source                      = "github.com/wso2/azure-terraform-modules//modules/azurerm/Private-DNS-A-Record?ref=v0.44.0"
    private_dns_a_record_name   = "traffic.manager1.external.svc.dc1"
    private_dns_zone_name       = var.private_dns_zone_name
    resource_group_name         = module.resource_group.resource_group_name
    time_to_live                = 300
    records                     = ["10.8.4.101"]
    tags                        = local.tags
    depends_on = [
        module.common_aks_cluster_dns
    ]
}
module "set_pvt_dns_A_records_tm2_DC1" {
    source                  = "github.com/wso2/azure-terraform-modules//modules/azurerm/Private-DNS-A-Record?ref=v0.44.0"
    private_dns_a_record_name   = "traffic.manager2.external.svc.dc1"
    private_dns_zone_name       = var.private_dns_zone_name
    resource_group_name         = module.resource_group.resource_group_name
    time_to_live                = 300
    records                     = ["10.8.4.102"]
    tags                        = local.tags
    depends_on = [
        module.common_aks_cluster_dns
    ]
}
module "set_pvt_dns_A_records_tm1_DC2" {
    source                      = "github.com/wso2/azure-terraform-modules//modules/azurerm/Private-DNS-A-Record?ref=v0.44.0"
    private_dns_a_record_name   = "traffic.manager1.external.svc.dc2"
    private_dns_zone_name       = var.private_dns_zone_name
    resource_group_name         = module.resource_group.resource_group_name
    time_to_live                = 300
    records                     = ["10.9.4.101"]
    tags                        = local.tags
    depends_on = [
        module.common_aks_cluster_dns
    ]
}
module "set_pvt_dns_A_records_tm2_DC2" {
    source                      = "github.com/wso2/azure-terraform-modules//modules/azurerm/Private-DNS-A-Record?ref=v0.44.0"
    private_dns_a_record_name   = "traffic.manager2.external.svc.dc2"
    private_dns_zone_name       = var.private_dns_zone_name
    resource_group_name         = module.resource_group.resource_group_name
    time_to_live                = 300
    records                     = ["10.9.4.101"]
    tags                        = local.tags
    depends_on = [
        module.common_aks_cluster_dns
    ]
}
module "set_pvt_dns_A_records_database" {
    source                      = "github.com/wso2/azure-terraform-modules//modules/azurerm/Private-DNS-A-Record?ref=v0.44.0"
    private_dns_a_record_name   = "mysql.service"
    private_dns_zone_name       = var.private_dns_zone_name
    resource_group_name         = module.resource_group.resource_group_name
    time_to_live                = 300
    records                     = ["10.8.4.103"]
    tags                        = local.tags
    depends_on = [
        module.common_aks_cluster_dns
    ]
}

              