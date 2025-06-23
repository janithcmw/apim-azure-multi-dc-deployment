#Create VM for the bastion.
resource "azurerm_network_interface" "bastion-vm-nic" {
  name                 = "nic-vm"
  resource_group_name  = local.resource_group_name
  location             = var.location

  ip_configuration {
    name                          = "bastion-vm-ip-config"
    subnet_id                     = module.bastion_vm_subnet.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = null
  }
}

resource "azurerm_linux_virtual_machine" "bastion-vm" {
  name                            = var.bastion_vm_name
  resource_group_name             = local.resource_group_name
  location                        = var.location
  size                            = "Standard_B2ats_v2"
  disable_password_authentication = false
  admin_username                  = "azureuser"
  admin_password                  = "@Aa123456789"
  network_interface_ids           = [azurerm_network_interface.bastion-vm-nic.id]
  priority                        = "Spot"
  eviction_policy                 = "Deallocate"

#  custom_data = filebase64("./install-tools.sh")

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.bastion-vm-identity.id]
  }

  os_disk {
    name                 = "os-disk-vm"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  boot_diagnostics {
    storage_account_uri = null
  }
}

resource "azurerm_user_assigned_identity" "bastion-vm-identity" {
  name                = "bastion-vm-identity"
  resource_group_name = local.resource_group_name
  location            = var.location
}

resource "azurerm_role_assignment" "vm-contributor" {
  scope                = data.azurerm_subscription.current.id
  role_definition_name = "Contributor"
  principal_id         = azurerm_user_assigned_identity.bastion-vm-identity.principal_id
}

data "azurerm_subscription" "current" {}