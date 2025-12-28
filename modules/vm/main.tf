# modules/vm/main.tf
resource "azurerm_network_interface" "nic" {
  for_each            = { for i in var.instances : i.name => i }
  name                = "${each.key}-nic"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
  }

  tags = var.tags
}

resource "azurerm_linux_virtual_machine" "vm" {
  for_each            = { for i in var.instances : i.name => i if lower(i.os_type) == "linux" }
  name                = each.key
  location            = var.location
  resource_group_name = var.resource_group_name
  size                = each.value.vm_size
  admin_username      = "azureuser"

  network_interface_ids = [azurerm_network_interface.nic[each.key].id]

  admin_ssh_key {
    username   = "azureuser"
    public_key = "ssh-rsa AAAA...replace..."
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

  tags = var.tags
}

# Diagnostics (example with LA workspace)
resource "azurerm_monitor_diagnostic_setting" "vm" {
  for_each           = azurerm_linux_virtual_machine.vm
  name               = "${each.key}-diag"
  target_resource_id = each.value.id
  log_analytics_workspace_id = var.diagnostics_workspace_id

  metric {
    category = "AllMetrics"
    enabled  = true
  }
}
