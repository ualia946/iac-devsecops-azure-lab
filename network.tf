resource "azurerm_virtual_network" "vn" {
  name                = "vnet-terraform-dev-francecentral"
  resource_group_name = azurerm_resource_group.rg.name
  location            = "France Central"
  address_space       = ["10.20.0.0/23"]


  tags = {
    Propietario = "Ivelin"
    Proyecto    = "Terraform"
    Entorno     = "Desarrollo"
  }
}

resource "azurerm_subnet" "appgateway" {
  name                 = "snet-appgateway"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vn.name
  address_prefixes     = ["10.20.0.0/25"]
}

resource "azurerm_subnet" "jumpbox" {
  name                 = "snet-jumpbox"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vn.name
  address_prefixes     = ["10.20.0.128/25"]
}

resource "azurerm_subnet" "containers" {
  name                 = "snet-containers"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vn.name
  address_prefixes     = ["10.20.1.0/25"]

  delegation {
    name = "container-delegation"
    service_delegation {
      name    = "Microsoft.ContainerInstance/containerGroups"
      actions = ["Microsoft.Network/virtualNetworks/subnets/join/action"]
    }
  }
}

resource "azurerm_subnet" "database" {
  name                 = "snet-database"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vn.name
  address_prefixes     = ["10.20.1.128/25"]

  delegation {
    name = "mysql-delegation"
    service_delegation {
      name    = "Microsoft.DBforMySQL/flexibleServers"
      actions = ["Microsoft.Network/virtualNetworks/subnets/join/action"]
    }
  }

}