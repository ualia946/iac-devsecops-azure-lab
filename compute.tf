resource "azurerm_public_ip" "public-ip-jumpbox" {
  name                = "ip-vm-jumpbox-terraform-dev-francecentral"
  resource_group_name = azurerm_resource_group.rg.name
  location            = "France Central"
  allocation_method   = "Static"
  sku                 = "Standard"

  tags = {
    Propietario = "Ivelin"
    Proyecto    = "Terraform"
    Entorno     = "Desarrollo"
  }
}

resource "azurerm_network_security_group" "nsg-jumpbox" {
  name                = "nsg-jumpbox-terraform-dev-francecentral"
  resource_group_name = azurerm_resource_group.rg.name
  location            = "France Central"

  security_rule {
    name                       = "allow-ssh"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = 22
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {
    Propietario = "Ivelin"
    Proyecto    = "Terraform"
    Entorno     = "Desarrollo"
  }
}


resource "azurerm_network_interface" "ni-jumpbox" {
  resource_group_name = azurerm_resource_group.rg.name
  name                = "nic-jumpbox-terraform-dev-francecentral"
  location            = "France Central"

  ip_configuration {
    private_ip_address_allocation = "Dynamic"
    name                          = "ipconfig1"
    subnet_id                     = azurerm_subnet.jumpbox.id
    public_ip_address_id          = azurerm_public_ip.public-ip-jumpbox.id

  }


  tags = {
    Propietario = "Ivelin"
    Proyecto    = "Terraform"
    Entorno     = "Desarrollo"
  }
}


resource "azurerm_network_interface_security_group_association" "assoc-jumpbox" {
  network_interface_id      = azurerm_network_interface.ni-jumpbox.id
  network_security_group_id = azurerm_network_security_group.nsg-jumpbox.id
}

resource "azurerm_linux_virtual_machine" "jumpbox" {
  resource_group_name = azurerm_resource_group.rg.name
  name                = "vm-jumpbox-terraform-dev-francecentral"
  location            = "francecentral"
  size                = "Standard_B1ls"

  admin_username                  = "ivelin"
  admin_password                  = var.jumpbox_password
  disable_password_authentication = false

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  network_interface_ids = [azurerm_network_interface.ni-jumpbox.id]


  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

  tags = {
    Propietario = "Ivelin"
    Proyecto    = "Terraform"
    Entorno     = "Desarrollo"
  }
}