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

/*
Used to store the terraform state file in Azure Blob Storage
*/
terraform {
  required_version = "= 1.12.2"
  backend "azurerm" {
    resource_group_name  = "rg-cst-api-app"
    storage_account_name = "tfstatestoragecst"
    container_name       = "terraform-private"
    key                  = "terraform.tfstate"
  }
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "= 4.0.0"
    }
  }
}
