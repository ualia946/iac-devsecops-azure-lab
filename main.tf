resource "azurerm_resource_group" "rg" {
  name     = "rg-terraform-dev-francecentral"
  location = "France Central"
  tags = {
    Propietario = "Ivelin"
    Proyecto    = "Terraform"
    Entorno     = "Desarrollo"
  }
}





