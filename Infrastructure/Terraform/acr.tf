#Attch the Existing Container registries to the clusters.
data "azurerm_container_registry" "acr" {
  name                = var.acr_name
  resource_group_name = var.acr_resource_group
}

resource "azurerm_role_assignment" "aks_cluster_1_acr_pull" {
  principal_id         = module.aks_cluster_1.aks_kubelet_identity
  role_definition_name = "AcrPull"
  scope                = data.azurerm_container_registry.acr.id
}

resource "azurerm_role_assignment" "aks_cluster_2_acr_pull" {
  principal_id         = module.aks_cluster_2.aks_kubelet_identity
  role_definition_name = "AcrPull"
  scope                = data.azurerm_container_registry.acr.id
}