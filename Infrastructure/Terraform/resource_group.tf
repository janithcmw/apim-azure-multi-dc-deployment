
# Provider Block Used. Default
provider "azurerm" {
    subscription_id = var.subscription_id
    features {}
}

# Provider that is used to access the shared resources that runs test VMs.
provider "azurerm" {   #commented due to role issue
    alias           = "shared_provider"
    subscription_id = var.subscription_id_shared
    features {}
}

# Creating resource group.
module "resource_group" {
    source                      = "github.com/wso2/azure-terraform-modules//modules/azurerm/Resource-Group?ref=v0.44.0"
    resource_group_name         = local.resource_group_name
    location                    = var.location
    tags                        = var.tags
}