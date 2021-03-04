
locals {
  resource_group_name                = "${var.resource_prefix}-rg"
  mamcontrolcentersql_vm_hostname    = "${var.resource_prefix}-mamsql"
  mamcontrolcentersqlScriptUrl       = "${var.script_url}${var.mamcontrolcentersqlScript}"
}

resource "azurerm_public_ip" "mamcontrolcentersql_ip" {
  count               = var.mamcontrolcentersql_nb_instances
  name                = "${local.mamcontrolcentersql_vm_hostname}-ip-${format("%02d",count.index)}"
  location            = var.resource_group_location
  resource_group_name = local.resource_group_name
  allocation_method   = "Dynamic"
}

resource "azurerm_network_interface" "mamcontrolcentersql_nic" {
  count                         = var.mamcontrolcentersql_nb_instances
  name                          = "${local.mamcontrolcentersql_vm_hostname}-nic-${format("%02d",count.index)}"
  location                      = var.resource_group_location
  resource_group_name           = local.resource_group_name
  enable_accelerated_networking = true

  ip_configuration {
    name                          = "ipconfig"
    subnet_id                     = var.vnet_subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = var.mamcontrolcentersql_internet_access ? azurerm_public_ip.mamcontrolcentersql_ip[count.index].id : ""
  }
}

resource "azurerm_virtual_machine" "mamcontrolcentersql_vm" {
  count                 = var.mamcontrolcentersql_nb_instances
  name                  = "${local.mamcontrolcentersql_vm_hostname}${format("%02d",count.index)}"
  location              = var.resource_group_location
  resource_group_name   = local.resource_group_name
  network_interface_ids = [azurerm_network_interface.mamcontrolcentersql_nic[count.index].id]
  vm_size               = var.mamcontrolcentersql_vm_size

  storage_image_reference {
    publisher = "MicrosoftSQLServer"
    offer     = "SQL2017-WS2019"
    sku       = "SQLDEV"
    version   = "laexample"
  }

  storage_os_disk {
    name              = "${local.mamcontrolcentersql_vm_hostname}-osdisk-${format("%02d",count.index)}"
    caching           = "ReadOnly"
    create_option     = "FromImage"
    managed_disk_type = "Premium_LRS"
  }

  os_profile {
    computer_name  = "${local.mamcontrolcentersql_vm_hostname}-vm-${format("%02d",count.index)}"
    admin_username = var.local_admin_username
    admin_password = var.local_admin_password
  }

  os_profile_windows_config {
    timezone                  = "Pacific Standard Time"
    provision_vm_agent        = true
    enable_automatic_upgrades = true
  }
}

resource "azurerm_mssql_virtual_machine" "mamcontrolcentersqlsql_vm" {
  count              = var.mamcontrolcentersql_nb_instances
  virtual_machine_id = azurerm_virtual_machine.mamcontrolcentersql_vm[count.index].id
  sql_license_type   = "PAYG"
}



