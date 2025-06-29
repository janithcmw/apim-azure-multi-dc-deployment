# This is used to handle the DNS and Vnet mappings.
#Fetch DNS zone that is created inside the aks_pool_cluster1 based on the resource group name.
data "azurerm_resources" "cluster1_pvt_dns_zones" {
  resource_group_name = join("-", ["rg", var.project, var.application_name, var.environment, var.location, var.cluster1_padding])
  type                = "Microsoft.Network/privateDnsZones"
  depends_on = [
    module.aks_cluster_1
  ]
}

#Define data block to get the DNS details of the fetched DNS zone in above of aks_pool_cluster1
data "azurerm_private_dns_zone" "cluster1_aks_private_dns_zone" {
  name                = local.cluster1_aks_private_dns_zone_name
  resource_group_name = join("-", ["rg", var.project, var.application_name, var.environment, var.location, var.cluster1_padding])
}

#Fetch DNS zone that is created inside the aks_pool_cluster2 based on the resource group name.
data "azurerm_resources" "cluster2_pvt_dns_zones" {
  resource_group_name = join("-", ["rg", var.project, var.application_name, var.environment, var.location, var.cluster2_padding])
  type                = "Microsoft.Network/privateDnsZones"
  depends_on = [
    module.aks_cluster_2
  ]
}

#Define data block to get the DNS details of the fetched DNS zone in above of aks_pool_cluster2
data "azurerm_private_dns_zone" "cluster2_aks_private_dns_zone" {
  name                = local.cluster2_aks_private_dns_zone_name
  resource_group_name = join("-", ["rg", var.project, var.application_name, var.environment, var.location, var.cluster2_padding])
}

# Link DNS zone of cluster1 to cluster2_virtual_network
module "cluster1_aks_dns_cluster2_vnet_link" {
  source                              = "github.com/wso2/azure-terraform-modules//modules/azurerm/Private-DNS-Zone-Vnet-Link?ref=v0.44.0"
  private_dns_zone_vnet_link_name     = "cluster1_aks_dns_to_cluster2_vnet_link"
  resource_group_name                 = join("-", ["rg", var.project, var.application_name, var.environment, var.location, var.cluster1_padding])
  private_dns_zone_name               = data.azurerm_private_dns_zone.cluster1_aks_private_dns_zone.name
  virtual_network_id                  = module.cluster2_virtual_network.virtual_network_id
  #registration_enabled                = true #not used in module, have to check why?
  depends_on = [
    module.aks_cluster_1,
    module.cluster2_virtual_network
  ]
}

# Link DNS zone of cluster2 to cluster1_virtual_network to
module "cluster2_aks_dns_cluster1_vnet_link" {
  source                              = "github.com/wso2/azure-terraform-modules//modules/azurerm/Private-DNS-Zone-Vnet-Link?ref=v0.44.0"
  private_dns_zone_vnet_link_name     = "cluster1_aks_dns_to_cluster2_vnet_link"
  resource_group_name                 = join("-", ["rg", var.project, var.application_name, var.environment, var.location, var.cluster2_padding])
  private_dns_zone_name               = data.azurerm_private_dns_zone.cluster2_aks_private_dns_zone.name
  virtual_network_id                  = module.cluster1_virtual_network.virtual_network_id
  #registration_enabled                = true #not used in module, have to check why?
  depends_on = [
    module.aks_cluster_2,
    module.cluster2_virtual_network
  ]
}

# Link DNS zone of cluster1 to shared_virtual_network
module "cluster1_aks_dns_shared_vnet_link" {
  source                              = "github.com/wso2/azure-terraform-modules//modules/azurerm/Private-DNS-Zone-Vnet-Link?ref=v0.44.0"
  private_dns_zone_vnet_link_name     = "cluster1_aks_dns_to_shared_vnet_link"
  resource_group_name                 = join("-", ["rg", var.project, var.application_name, var.environment, var.location, var.cluster1_padding])
  private_dns_zone_name               = data.azurerm_private_dns_zone.cluster1_aks_private_dns_zone.name
  virtual_network_id                  = data.azurerm_virtual_network.shared_vnet.id
  #registration_enabled                = true #not used in module, have to check why?
  depends_on = [
    module.aks_cluster_1
  ]
}

# Link DNS zone of cluster2 to shared_virtual_network
module "cluster2_aks_dns_shared_vnet_link" {
  source                              = "github.com/wso2/azure-terraform-modules//modules/azurerm/Private-DNS-Zone-Vnet-Link?ref=v0.44.0"
  private_dns_zone_vnet_link_name     = "cluster1_aks_dns_to_shared_vnet_link"
  resource_group_name                 = join("-", ["rg", var.project, var.application_name, var.environment, var.location, var.cluster2_padding])
  private_dns_zone_name               = data.azurerm_private_dns_zone.cluster2_aks_private_dns_zone.name
  virtual_network_id                  = data.azurerm_virtual_network.shared_vnet.id
  #registration_enabled                = true #not used in module, have to check why?
  depends_on = [
    module.aks_cluster_2
  ]
}