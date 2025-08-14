resource "azurerm_mysql_flexible_server" "db" {
  name                = "db-terraform-dev-francecentral"
  resource_group_name = azurerm_resource_group.rg.name
  location            = "France Central"

  administrator_login    = "ivelin"
  administrator_password = var.db_password

  sku_name = "B_Standard_B1ms"
  version  = "8.0.21"

  delegated_subnet_id = azurerm_subnet.database.id
  private_dns_zone_id = azurerm_private_dns_zone.dns.id



  depends_on = [azurerm_private_dns_zone_virtual_network_link.vnet-link]

  tags = {
    Propietario = "Ivelin"
    Proyecto    = "Terraform"
    Entorno     = "Desarrollo"
  }
}

resource "azurerm_mysql_flexible_server_configuration" "disable_ssl" {
  name                = "require_secure_transport"
  resource_group_name = azurerm_resource_group.rg.name
  server_name         = azurerm_mysql_flexible_server.db.name
  value               = "OFF"
}

resource "azurerm_private_dns_zone" "dns" {
  name                = "private.mysql.database.azure.com"
  resource_group_name = azurerm_resource_group.rg.name

  tags = {
    Propietario = "Ivelin"
    Proyecto    = "Terraform"
    Entorno     = "Desarrollo"
  }
}

resource "azurerm_private_dns_zone_virtual_network_link" "vnet-link" {
  name                  = "vnet-link-to-dns-zone"
  resource_group_name   = azurerm_resource_group.rg.name
  private_dns_zone_name = azurerm_private_dns_zone.dns.name
  virtual_network_id    = azurerm_virtual_network.vn.id

  tags = {
    Propietario = "Ivelin"
    Proyecto    = "Terraform"
    Entorno     = "Desarrollo"
  }
}