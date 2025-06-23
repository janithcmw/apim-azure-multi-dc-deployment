#Assing network contributor of subnet to AKS.
module "cluster1_subnet" {
  source = "github.com/wso2/azure-terraform-modules//modules/azurerm/Static-IP-Custom-Virtual-Machine?ref=v0.44.0"
  vm_name                   = var.bastion_vm_name
  resource_group_name       = module.resource_group.resource_group_name
  location                  = var.location
  size                      = var.bastion_vm_size
  admin_username            = var.bastion_admin_username
  computer_name             = var.bastion_computer_name
  source_image_id           = "Canonical:0001-com-ubuntu-server-focal:20_04-lts:latest"
  public_key_path           = var.bastion_public_ssh_key_path
  os_disk_name              = join("-", [var.bastion_vm_name, "disk"])
  os_disk_size_gb           = 30
  nic_name                  = "bastion_vm_nic"
  nic_ip_configuration_name = "bastion_vm_nic_ip_conf"
  subnet_id                 = module.bastion_vm_subnet.subnet_id
  private_ip_address        = "10.1.2.22"
  tags                      = local.tags
}