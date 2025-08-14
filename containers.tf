resource "azurerm_container_registry" "acr-dvwa" {
  name                = "acrterraformdvwadev"
  resource_group_name = azurerm_resource_group.rg.name
  location            = "France Central"
  sku                 = "Basic"
  admin_enabled       = true
}

resource "azurerm_container_group" "aci-terraform-dvwa" {
  name                = "aci-terraform-dev-francecentral"
  resource_group_name = azurerm_resource_group.rg.name
  location            = "France Central"
  os_type             = "Linux"

  ip_address_type = "Private"
  subnet_ids      = [azurerm_subnet.containers.id]

  image_registry_credential {
    server   = azurerm_container_registry.acr-dvwa.login_server
    username = azurerm_container_registry.acr-dvwa.admin_username
    password = azurerm_container_registry.acr-dvwa.admin_password
  }

  container {
    name   = "dvwa"
    image  = "${azurerm_container_registry.acr-dvwa.login_server}/dvwa-web:v1"
    cpu    = "1.0"
    memory = "1.0"
    ports {
      port     = 80
      protocol = "TCP"
    }
    environment_variables = {
      "DB_SERVER"   = azurerm_mysql_flexible_server.db.fqdn
      "DB_DATABASE" = "dvwa"
      "DB_USER"     = azurerm_mysql_flexible_server.db.administrator_login
      "DB_PASSWORD" = var.db_password
    }
  }

  tags = {
    Propietario = "Ivelin"
    Proyecto    = "Terraform"
    Entorno     = "Desarrollo"
    Version     = "v1"
  }
}