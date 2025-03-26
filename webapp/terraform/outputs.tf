output "app_service_url" {
  description = "The URL to access the deployed App Service"
  value       = azurerm_app_service.app_service.default_site_hostname
}

output "postgresql_fqdn" {
  description = "The fully qualified domain name of the PostgreSQL server"
  value       = azurerm_postgresql_flexible_server.postgresql.fqdn
}