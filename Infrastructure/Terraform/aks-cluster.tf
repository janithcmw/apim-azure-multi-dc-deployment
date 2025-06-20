# Aks module
module "aks_cluster_1" {
  source = "github.com/wso2/azure-terraform-modules//modules/azurerm/AKS-Generic?ref=v0.44.0"
  # Cluster configurations
  aks_cluster_name                                     = join("-", [var.project, var.application_name, var.environment, var.location, var.cluster1_padding])
  aks_cluster_dns_prefix                               = join("-", [var.cluster1_aks_cluster_dns_prefix, var.cluster1_padding])
  location                                             = var.location
  aks_resource_group_name                              = module.resource_group.resource_group_name
  virtual_network_resource_group_name                  = module.resource_group.resource_group_name
  log_analytics_workspace_id                           = module.cluster1_log_analytics.log_analytics_workspace_id
  private_cluster_enabled                              = var.private_cluster_enabled
  kubernetes_version                                   = var.kubernetes_version
  default_node_pool_name                               = join("", [var.default_node_pool_name, var.cluster1_padding])
  default_node_pool_vm_size                            = var.default_node_pool_vm_size
  default_node_pool_os_disk_size_gb                    = var.default_node_pool_os_disk_size_gb
  default_node_pool_max_count                          = var.default_node_pool_max_count
  default_node_pool_min_count                          = var.default_node_pool_min_count
  default_node_pool_count                              = var.default_node_pool_count
  default_node_pool_only_critical_addons_enabled       = var.default_node_pool_only_critical_addons_enabled
  default_node_pool_orchestrator_version               = var.default_node_pool_orchestrator_version
  default_node_pool_availability_zones                 = var.default_node_pool_availability_zones
  default_node_pool_max_pods                           = var.default_node_pool_max_pods
  aks_node_pool_resource_group_name                    = join("-", [var.project, var.application_name, var.environment, var.location, var.cluster1_padding])
  aks_node_pool_subnet_address_prefix                  = var.cluster1_aks_node_pool_subnet_address_prefix
  aks_node_pool_subnet_name                            = join("-", [module.cluster1_virtual_network.virtual_network_name, "nodepool"])
  virtual_network_name                                 = module.cluster1_virtual_network.virtual_network_name
  aks_node_pool_subnet_network_security_group_name     = join("-", ["nodepool", var.project, var.application_name, var.environment, var.location, var.cluster1_padding])
  aks_node_pool_subnet_route_table_name                = join("-", [var.project, var.application_name, var.environment, var.location, var.cluster1_padding])
  aks_node_pool_subnet_nsg_rules                       = var.aks_node_pool_subnet_nsg_rules # two this is working? I do not need to specify any ips, can I skip
  service_cidr                                         = var.cluster1_service_cidr
  dns_service_ip                                       = var.cluster1_dns_service_ip
  outbound_type                                        = var.outbound_type  # default type is also loadBalancer
  aks_load_balancer_subnet_nsg_rules                   = var.aks_load_balancer_subnet_nsg_rules # two this is working? I do not need to specify any ips, can I skip
  aks_load_balancer_subnet_network_security_group_name = join("-", ["loadbalancer", var.project, var.application_name, var.environment, var.location, var.cluster1_padding])
  aks_load_balancer_subnet_name                        = join("-", [module.cluster1_virtual_network.virtual_network_name, "loadbalancer"])
  internal_loadbalancer_subnet_address_prefix          = var.cluster1_internal_loadbalancer_subnet_address_prefix
  aks_admin_username                                   = var.aks_admin_username
  aks_public_ssh_key_path                              = var.aks_public_ssh_key_path
  azure_policy_enabled                                 = var.azure_policy_enabled
}


# Aks module
module "aks_cluster_2" {
  source = "github.com/wso2/azure-terraform-modules//modules/azurerm/AKS-Generic?ref=v0.44.0"
  # Cluster configurations
  aks_cluster_name                                     = join("-", [var.project, var.application_name, var.environment, var.location, var.cluster2_padding])
  aks_cluster_dns_prefix                               = join("-", [var.cluster2_aks_cluster_dns_prefix, var.cluster2_padding])
  location                                             = var.location
  aks_resource_group_name                              = module.resource_group.resource_group_name
  virtual_network_resource_group_name                  = module.resource_group.resource_group_name
  log_analytics_workspace_id                           = module.cluster2_log_analytics.log_analytics_workspace_id
  private_cluster_enabled                              = var.private_cluster_enabled
  kubernetes_version                                   = var.kubernetes_version
  default_node_pool_name                               = join("", [var.default_node_pool_name, var.cluster2_padding])
  default_node_pool_vm_size                            = var.default_node_pool_vm_size
  default_node_pool_os_disk_size_gb                    = var.default_node_pool_os_disk_size_gb
  default_node_pool_max_count                          = var.default_node_pool_max_count
  default_node_pool_min_count                          = var.default_node_pool_min_count
  default_node_pool_count                              = var.default_node_pool_count
  default_node_pool_only_critical_addons_enabled       = var.default_node_pool_only_critical_addons_enabled
  default_node_pool_orchestrator_version               = var.default_node_pool_orchestrator_version
  default_node_pool_availability_zones                 = var.default_node_pool_availability_zones
  default_node_pool_max_pods                           = var.default_node_pool_max_pods
  aks_node_pool_resource_group_name                    = join("-", [var.project, var.application_name, var.environment, var.location, var.cluster2_padding])
  aks_node_pool_subnet_address_prefix                  = var.cluster2_aks_node_pool_subnet_address_prefix
  aks_node_pool_subnet_name                            = join("-", [module.cluster2_virtual_network.virtual_network_name, "nodepool"])
  virtual_network_name                                 = module.cluster2_virtual_network.virtual_network_name
  aks_node_pool_subnet_network_security_group_name     = join("-", ["nodepool", var.project, var.application_name, var.environment, var.location, var.cluster2_padding])
  aks_node_pool_subnet_route_table_name                = join("-", [var.project, var.application_name, var.environment, var.location, var.cluster2_padding])
  aks_node_pool_subnet_nsg_rules                       = var.aks_node_pool_subnet_nsg_rules
  service_cidr                                         = var.cluster2_service_cidr
  dns_service_ip                                       = var.cluster2_dns_service_ip
  outbound_type                                        = var.outbound_type
  aks_load_balancer_subnet_nsg_rules                   = var.aks_load_balancer_subnet_nsg_rules
  aks_load_balancer_subnet_network_security_group_name = join("-", ["loadbalancer", var.project, var.application_name, var.environment, var.location, var.cluster2_padding])
  aks_load_balancer_subnet_name                        = join("-", [module.cluster2_virtual_network.virtual_network_name, "loadbalancer"])
  internal_loadbalancer_subnet_address_prefix          = var.cluster1_internal_loadbalancer_subnet_address_prefix
  aks_admin_username                                   = var.aks_admin_username
  aks_public_ssh_key_path                              = var.aks_public_ssh_key_path
  azure_policy_enabled                                 = var.azure_policy_enabled
}

#With the above aks cluster creation, tow subnets will be created, 'snet-{var.aks_node_pool_subnet_name}' and 'snet-{var.aks_load_balancer_subnet_name}' In the 'network.tf' new vnets will be created for the subnets
