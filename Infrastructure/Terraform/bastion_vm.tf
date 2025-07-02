## Create a subnet for the VM.
#module "bastion_vm_subnet" {
#  source                      = "github.com/wso2/azure-terraform-modules//modules/azurerm/Subnet?ref=v2.1.0"
#  subnet_name                 = var.bastion_vm_subnet_name
#  resource_group_name         = module.resource_group.resource_group_name
#  location                    = var.location
#  virtual_network_name        = module.cluster1_virtual_network.virtual_network_name
#  address_prefix              = ["10.8.3.0/24"]
#  network_security_group_name = var.bastion_nsg_name
#  tags                        = local.tags
#}
#
## Create the bastion VM.
#resource "azurerm_linux_virtual_machine" "bastion_vm" {
#  name                = "jump-box-virtual-machine"
#  resource_group_name = module.resource_group.resource_group_name
#  location            = var.location
#  size                = var.bastion_vm_size
#  admin_username      = var.bastion_admin_username
#
#  network_interface_ids = [
#    azurerm_network_interface.bastion_vm_nic.id
#  ]
#
#  custom_data = filebase64("./install-bastion-vm-tools.sh")
#
#  admin_ssh_key {
#    username   = var.bastion_admin_username
#    public_key = file(var.aks_public_ssh_key_path)
#  }
#
#  os_disk {
#    caching              = "ReadWrite"
#    storage_account_type = "Standard_LRS"
#  }
#
#  source_image_reference {
#    publisher = "Canonical"
#    offer     = "UbuntuServer"
#    sku       = "18.04-LTS"
#    version   = "18.04.202401161"
#  }
#}
#
## Network Interface with static private IP
#resource "azurerm_network_interface" "bastion_vm_nic" {
#  name                = var.bastion_vm_nic_name
#  location            = var.location
#  resource_group_name = module.resource_group.resource_group_name
#
#  ip_configuration {
#    name                          = "internal"
#    subnet_id                     = module.bastion_vm_subnet.subnet_id
#    private_ip_address_allocation = "Static"
#    private_ip_address            = "10.8.3.111"
#  }
#}
