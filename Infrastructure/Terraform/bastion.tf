# Adding bastion for both Aks clusters.
module "bastion" {
  source = "github.com/wso2/azure-terraform-modules//modules/azurerm/Bastion-Host?ref=v2.1.0"
  bastion_host_abbreviation     = "cluster1_aks"
  bastion_host_name             = "bastion"
  resource_group_name           = module.resource_group.resource_group_name
  location                      = var.location
  file_copy_enabled             = true
  ip_connect_enabled            = true
  scale_units                   = 2
  shareable_link_enabled        = true
  tunneling_enabled             = false
  sku                           = "Standard"
  tags                          = var.tags
  bastion_subnet_name           = "cluster1_subnet_for_bastion"
  virtual_network_name          = module.cluster1_virtual_network.virtual_network_name
  subnet_address_prefixes       = "10.1.2.0/24"
  allow_https_internet_inbound  = true
  public_ip_abbreviation        = "cluster1_aks_ip"
  public_ip_name                = "bastion"
  public_address_prefixes       = ["203.0.113.45/32", "198.51.100.0/28"]
  network_security_group_name   = "bastion_host_nsg"

}

