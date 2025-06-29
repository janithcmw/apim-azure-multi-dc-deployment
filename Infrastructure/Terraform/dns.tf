# This is used to handle the DNS and Vnet mappings.
data "azurerm_resources" "cluster_1_pvt_dns_zones" {
  resource_group_name = join("-", ["rg", var.project, var.application_name, var.environment, var.location, var.cluster1_padding])
  type                = "Microsoft.Network/privateDnsZones"
  depends_on = [
    module.aks_cluster_1
  ]
}

data "azurerm_private_dns_zone" "cluster1_aks_private_dns_zone" {
  name                = local.cluster1_aks_private_dns_zone_name
  resource_group_name = join("-", ["rg", var.project, var.application_name, var.environment, var.location, var.cluster1_padding])
}

# Link cluster2_virtual_network to DNS zone of cluster1
module "cluster1_aks_dns_cluster2_vnet_link" {
  source                              = "github.com/wso2/azure-terraform-modules//modules/azurerm/Private-DNS-Zone-Vnet-Link?ref=v0.44.0"
  private_dns_zone_vnet_link_name     = "cluster1_virtual_network-dns-link"
  resource_group_name                 = module.resource_group.resource_group_name
  private_dns_zone_name               = data.azurerm_private_dns_zone.cluster1_aks_private_dns_zone.name
  virtual_network_id                  = module.cluster2_virtual_network.virtual_network_id
  #registration_enabled                = true #not used in module, have to check why?
  depends_on = [
    module.common_aks_cluster_dns
  ]
}