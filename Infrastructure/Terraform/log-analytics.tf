#Configure log analytics for each cluster.
module "cluster1_log_analytics" {
    source                          = "github.com/wso2/azure-terraform-modules//modules/azurerm/Log-Analytics-Workspace?ref=v0.44.0"
    log_analytics_workspace_name    = local.cluster1_log_analytics_workspace_name
    location                        = var.location
    resource_group_name             = module.resource_group.resource_group_name
    log_analytics_workspace_sku     = "PerGB2018"
    log_retention_in_days           = 7
    daily_quota_gb                  = -1
    internet_ingestion_enabled      = true
    internet_query_enabled          = true
    tags                            = local.tags
    log_analytics_solution_enabled  = true
    log_analytics_solution_name     = "ContainerInsights"
}

module "cluster2_log_analytics" {
    source                          = "github.com/wso2/azure-terraform-modules//modules/azurerm/Log-Analytics-Workspace?ref=v0.44.0"
    log_analytics_workspace_name    = local.cluster2_log_analytics_workspace_name
    location                        = var.location
    resource_group_name             = module.resource_group.resource_group_name
    log_analytics_workspace_sku     = "PerGB2018"
    log_retention_in_days           = 7
    daily_quota_gb                  = -1
    internet_ingestion_enabled      = true
    internet_query_enabled          = true
    tags                            = local.tags
    log_analytics_solution_enabled  = true
    log_analytics_solution_name     = "ContainerInsights"
}