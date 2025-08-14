output "jumpbox_public_ip" {
  description = "La dirección IP pública de la VM Jump Box para acceso SSH."
  value       = azurerm_public_ip.public-ip-jumpbox.ip_address
}

output "appgateway_public_ip" {
  description = "La dirección IP pública del Application Gateway para acceder a la aplicación."
  value       = azurerm_public_ip.public-ip-appgateway.ip_address
}