# -------------------------------------------------------------------------------------
#
# Copyright (c) 2024, WSO2 LLC. (http://www.wso2.com). All Rights Reserved.
#
# This software is the property of WSO2 LLC. and its suppliers, if any.
# Dissemination of any information or reproduction of any material contained
# herein in any form is strictly forbidden, unless permitted by WSO2 expressly.
# You may not alter or remove any copyright or other notice from copies of this content.
#
# --------------------------------------------------------------------------------------

locals {
  cluster1_log_analytics_workspace_name = join("-", [var.project, var.application_name, var.environment, var.location, var.cluster1_padding])
  cluster2_log_analytics_workspace_name = join("-", [var.project, var.application_name, var.environment, var.location, var.cluster2_padding])
  resource_group_name                   = join("-", [var.project, var.application_name, var.environment, var.location])
  cluster1_virtual_network_name         = join("-", [var.project, var.application_name, var.environment, var.location, var.cluster1_padding])
  cluster2_virtual_network_name         = join("-", [var.project, var.application_name, var.environment, var.location, var.cluster2_padding])
  tags                                  = {tag = join("-", ["tag", var.project, var.application_name, var.environment, var.location])}
  cluster1_aks_private_dns_zone_name = [
    for r in data.azurerm_resources.cluster_1_pvt_dns_zones.resources :
    r.name if can(regex("privatelink", r.name))
  ][0]
}
