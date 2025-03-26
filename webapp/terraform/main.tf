provider "azurerm" {
  features {}
}


# Resource Group
resource "azurerm_resource_group" "release_location" {
  name     = "${var.project_name}-${var.environment}"
  location = var.location
}

# Virtual Network
resource "azurerm_virtual_network" "vnet" {
  name                = "${var.project_name}-${var.environment}-vnet"
  location            = azurerm_resource_group.release_location.location
  resource_group_name = azurerm_resource_group.release_location.name
  address_space       = ["10.0.0.0/16"]
}

# Subnet
resource "azurerm_subnet" "subnet" {
  name                 = "${var.project_name}-${var.environment}-subnet"
  resource_group_name  = azurerm_resource_group.release_location.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

# PostgreSQL Flexible Server
resource "azurerm_postgresql_flexible_server" "postgresql" {
  name                = "${var.project_name}-${var.environment}-postgresql-db"
  location            = azurerm_resource_group.release_location.location
  resource_group_name = azurerm_resource_group.release_location.name

  # Administrator details
  administrator_login    = "dbadmin"
  administrator_password = var.postgresql_admin_password

  # Database server properties
  sku_name               = "Standard_B1ms"
  version                = "14"
  storage_mb             = 5120  # 5GB Storage
  backup_retention_days  = 7

  # Connect database to the private subnet
  delegated_subnet_id = azurerm_subnet.subnet.id

  high_availability {
    mode = "Disabled"
  }

  tags = {
    environment = var.environment
  }
}

# PostgreSQL Database Schema
resource "azurerm_postgresql_flexible_database" "db_schema" {
  name                = var.postgresql_database_name
  resource_group_name = azurerm_resource_group.release_location.name
  server_name         = azurerm_postgresql_flexible_server.postgresql.name
  charset             = "UTF8"
  collation           = "en_US.UTF8"
}

# Private Endpoint for PostgreSQL
resource "azurerm_private_endpoint" "postgresql_private_endpoint" {
  name                = "${var.project_name}-${var.environment}-postgresql"
  location            = azurerm_resource_group.release_location.location
  resource_group_name = azurerm_resource_group.release_location.name
  subnet_id           = azurerm_subnet.subnet.id

  private_service_connection {
    name                           = "postgresql-connection"
    private_connection_resource_id = azurerm_postgresql_flexible_server.postgresql.id
    is_manual_connection           = false
  }
}

# App Service Plan
resource "azurerm_app_service_plan" "plan" {
  name                = "${var.project_name}-${var.environment}-plan"
  location            = azurerm_resource_group.release_location.location
  resource_group_name = azurerm_resource_group.release_location.name
  kind                = "Linux"
  reserved            = true

  sku {
    tier = "Basic"
    size = "B1"
  }
}

# App Service
resource "azurerm_app_service" "app_service" {
  name                = "${var.project_name}-${var.environment}-app"
  location            = azurerm_resource_group.release_location.location
  resource_group_name = azurerm_resource_group.release_location.name
  app_service_plan_id = azurerm_app_service_plan.plan.id

  identity {
    type = "SystemAssigned"
  }

  app_settings = {
    POSTGRESQL_CONNECTION = "postgresql://${azurerm_postgresql_flexible_server.postgresql.administrator_login}:${var.postgresql_admin_password}@${azurerm_postgresql_flexible_server.postgresql.fqdn}/${var.postgresql_database_name}?sslmode=require"
    WEBSITES_ENABLE_APP_SERVICE_STORAGE = false
  }

  tags = {
    environment = var.environment
  }
}
