variable "prefix" {
  description = "Name prefix for resources"
  type        = string
  default     = "demo"
}

variable "resource_group_name" {
  description = "Resource Group name"
  type        = string
  default     = "rg-demo-hub-spoke"
}

variable "location" {
  description = "Azure region"
  type        = string
  default     = "westeurope"
}

variable "sql_admin" {
  description = "SQL administrator username"
  type        = string
  default     = "sqladminuser"
}

variable "sql_password" {
  description = "SQL administrator password"
  type        = string
  default     = "P@ssw0rd1234!"
  sensitive   = true
}
