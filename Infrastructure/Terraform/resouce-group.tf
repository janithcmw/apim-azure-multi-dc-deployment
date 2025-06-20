
# Provider Block
provider "azurerm" {
  # subscription_id = var.subscription_id
  features {}
}

# Creating resouce group.
module "resouce_group" {
    source                      = "github.com/wso2/azure-terraform-modules//modules/azurerm/Resource-Group?ref=v0.44.0"
    resource_group_name         = local.resource_group_name
    tags                        = var.tags
}