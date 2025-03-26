variable "project_name" {
  description = "Name of the project"
  default     = "myproject"
}

variable "environment" {
  description = "Environment for the deployment (e.g., dev, staging, production)"
}

variable "location" {
  description = "Azure region for deployment"
  default     = "East US"
}

variable "postgresql_admin_password" {
  description = "Admin password for PostgreSQL"
  type        = string
  sensitive   = true
}

variable "postgresql_database_name" {
  description = "Name for the PostgreSQL database"
  default     = "app_db"
}