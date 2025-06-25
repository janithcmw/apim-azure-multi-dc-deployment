# Handle the current cluster and the test VM connectivity.

#Get existing vnet data.
data "azurerm_virtual_network" "shared_vnet" {
  provider            = azurerm.shared_provider
  name                = var.vnet_name_shared
  resource_group_name = var.resource_group_name_shared
}

# Handle peering between the cluster and the existing test execution VMs.
module "cluster1_virtual_network_to_shared_vnet" {
  source                              = "github.com/wso2/azure-terraform-modules//modules/azurerm/Vnet-Peering?ref=v0.44.0"
  custom_peering_dest_name            = "cluster1_virtual_network_to_shared_vnet"
  vnet_src_id                         = module.cluster1_virtual_network.virtual_network_id
  vnet_dest_id                        = data.azurerm_virtual_network.shared_vnet.id
  allow_virtual_src_network_access    = true
  allow_forwarded_src_traffic         = true
}

module "shared_vnet_to_cluster1_virtual_network" {
  source                              = "github.com/wso2/azure-terraform-modules//modules/azurerm/Vnet-Peering?ref=v0.44.0"
  custom_peering_dest_name            = "cluster1_virtual_network_to_shared_vnet"
  vnet_src_id                         = data.azurerm_virtual_network.shared_vnet.id
  vnet_dest_id                        = module.cluster1_virtual_network.virtual_network_id
  allow_virtual_src_network_access    = true
  allow_forwarded_src_traffic         = true
}

module "cluster2_virtual_network_to_shared_vnet" {
  source                              = "github.com/wso2/azure-terraform-modules//modules/azurerm/Vnet-Peering?ref=v0.44.0"
  custom_peering_dest_name            = "cluster1_virtual_network_to_shared_vnet"
  vnet_src_id                         = module.cluster2_virtual_network.virtual_network_id
  vnet_dest_id                        = data.azurerm_virtual_network.shared_vnet.id
  allow_virtual_src_network_access    = true
  allow_forwarded_src_traffic         = true
}

module "shared_vnet_to_cluster2_virtual_network" {
  source                              = "github.com/wso2/azure-terraform-modules//modules/azurerm/Vnet-Peering?ref=v0.44.0"
  custom_peering_dest_name            = "cluster1_virtual_network_to_shared_vnet"
  vnet_src_id                         = data.azurerm_virtual_network.shared_vnet.id
  vnet_dest_id                        = module.cluster2_virtual_network.virtual_network_id
  allow_virtual_src_network_access    = true
  allow_forwarded_src_traffic         = true
}

# Link cluster DNS with the DNS of test execution VMs.
module "common_cluster_dns_shared_vnet_link" {
  source                              = "github.com/wso2/azure-terraform-modules//modules/azurerm/Private-DNS-Zone-Vnet-Link?ref=v0.44.0"
  private_dns_zone_vnet_link_name     = "shared_network_dns_link"
  resource_group_name                 = module.resource_group.resource_group_name
  private_dns_zone_name               = var.private_dns_zone_name
  virtual_network_id                  = data.azurerm_virtual_network.shared_vnet.id
  #registration_enabled                = true #not used in module, have to check why?
  depends_on = [
    module.common_aks_cluster_dns
  ]
}