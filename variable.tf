variable "deflow_resource_group_name" {
type = string
description = "This is for resource group name"
default = "devflow-project-group6-rg"
}

variable "devflow_location" {
type = string
description = "The location where the resource will be created"
default = "Canada Central"
}

variable "devflow_mssql_server_name" {
type = string
description = "Name of mssql server instance"
default = "devflow-group6-mssql-server"
}

variable "devflow_mssql_server_version" {
type = string
description = "The version of mssql server instance"
default = "12.0"
}

variable "devflow_mssql_server_admin" {
type = string
description = "The name of admin of the mssql server instance"
default = "missadministrator"
}

variable "devflow_mssql_server_password" {
type = string
description = "The password for the mssql server instance"
default = "thisIsKat11"
}

variable "devflow_mssql_server_tls_version" {
type = string
description = "The tls version of the mssql server instance"
default = "1.2"
}

variable "devflow_tags" {
type = map(string)
description = "Tag of the devflow resources"
default = {
"Environment" = "Development"
"Created with" = "Terraform"
}
}

variable "devflow_mssql_server_database_name" {
type = string
description = "MSSQL server database name"
default = "devflow-group6-db"
}

variable "devflow_key_vault_name" {
type = string
description = "The name of devflow key vault"
default = "devflowgroup6keyvault"
}

variable "devflow_key_vault_enabled_for_disk_encryption" {
type = bool
description = "flag use to enabled for disk encryption of the key vault"
default = true
}

variable "devflow_purge_protection_enabled" {
type = bool
description = "flag use to enable purge protection for key vault"
default = false
}

variable "devflow_soft_delete_retention_days" {
type = number
description = "soft delete retention days"
default = 7
}

variable "deflow_key_vault_sku_name" {
type = string
description = "key vault sku name"
default = "standard"
}

variable "devflow_key_vault_key_permissions" {
type = list(string)
description = "key permissions"
default = [ "Get", "List" ]
}

variable "devflow_key_vault_secret_permissions" {
type = list(string)
description = "secret permissions"
default = [ "Get", "List" ]
}

variable "subscription_id" {
type = string
description = "subscription id"
default = "a806834c-3019-42c1-867a-d95f6041277b"
}

variable "deflow_app_service_plan_name" {
type = string
description = "deflow app service plan name"
default = "devflowappserviceplangroup6"
}

variable "deflow_app_service_name" {
type = string
description = "deflow app name"
default = "devflowappservicegroup6"
}

variable "deflow_app_service_plan_os_type" {
type = string
description = "deflow app service plan os type"
default = "Windows"
}

variable "devflow_app_service_plan_sku_name" {
type = string
description = "deflow app service plan os type"
default = "F1"
}