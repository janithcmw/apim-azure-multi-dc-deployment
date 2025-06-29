# Used for debugging purpose, defining outputs.
output "cluster1_aks_private_dns_zone_name" {
  value = [
    for r in data.azurerm_resources.cluster1_pvt_dns_zones.resources :
    r.name if can(regex("privatelink", r.name))
  ]
}

output "cluster1_dns_zone_name_from_data_block" {
  value = data.azurerm_private_dns_zone.cluster1_aks_private_dns_zone.name
}


output "cluster2_aks_private_dns_zone_name" {
  value = [
    for r in data.azurerm_resources.cluster2_pvt_dns_zones.resources :
    r.name if can(regex("privatelink", r.name))
  ]
}

output "cluster2_dns_zone_name_from_data_block" {
  value = data.azurerm_private_dns_zone.cluster2_aks_private_dns_zone.name
}