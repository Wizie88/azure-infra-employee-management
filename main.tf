resource "azurerm_resource_group" "devflow_resource_group" {
name = var.deflow_resource_group_name
location = var.devflow_location
tags = var.devflow_tags
}

resource "azurerm_mssql_server" "devflow_mssql_server" {
  name                         = var.devflow_mssql_server_name
  resource_group_name          = azurerm_resource_group.devflow_resource_group.name
  location                     = azurerm_resource_group.devflow_resource_group.location
  version                      = var.devflow_mssql_server_version
  administrator_login          = var.devflow_mssql_server_admin
  administrator_login_password = var.devflow_mssql_server_password
  minimum_tls_version          = var.devflow_mssql_server_tls_version
  tags = var.devflow_tags
}

resource "azurerm_mssql_database" "devflow_mssql_server_database" {
  name         = var.devflow_mssql_server_database_name
  server_id    = azurerm_mssql_server.devflow_mssql_server.id
  tags = var.devflow_tags
}

data "azurerm_client_config" "devflow_client_config" {}
resource "azurerm_key_vault" "devflow_key_vault" {
  name                                                  = var.devflow_key_vault_name
  location                                             = azurerm_resource_group.devflow_resource_group.location
  resource_group_name                  = azurerm_resource_group.devflow_resource_group.name
  enabled_for_disk_encryption     = var.devflow_key_vault_enabled_for_disk_encryption
  tenant_id                                         = data.azurerm_client_config.devflow_client_config.tenant_id
  soft_delete_retention_days       = var.devflow_soft_delete_retention_days
  purge_protection_enabled         = var.devflow_purge_protection_enabled
  sku_name                                       = var.deflow_key_vault_sku_name
}

resource "azurerm_key_vault_access_policy" "devflow_key_vault_access_policy" {
  depends_on    = [ azurerm_key_vault.devflow_key_vault ]
  key_vault_id   = azurerm_key_vault.devflow_key_vault.id
  tenant_id         = data.azurerm_client_config.devflow_client_config.tenant_id
  object_id          = data.azurerm_client_config.devflow_client_config.object_id
  key_permissions = var.devflow_key_vault_key_permissions
  secret_permissions = var.devflow_key_vault_secret_permissions
}

# App Service Plan
resource "azurerm_service_plan" "devflow-service-plan" {
  depends_on                         = [ azurerm_resource_group.devflow_resource_group ]
  name                                     = var.deflow_app_service_plan_name
  location                                 = azurerm_resource_group.devflow_resource_group.location
  resource_group_name      = azurerm_resource_group.devflow_resource_group.name  
  os_type                                 = var.deflow_app_service_plan_os_type
  sku_name                             = var.devflow_app_service_plan_sku_name
}

# App Service
resource "azurerm_windows_web_app" "tech-integration-web-app" {
  depends_on = [ azurerm_resource_group.devflow_resource_group, azurerm_service_plan.devflow-service-plan, azurerm_key_vault.devflow_key_vault ]
  name                = var.deflow_app_service_name
  location            = azurerm_resource_group.devflow_resource_group.location
  resource_group_name = azurerm_resource_group.devflow_resource_group.name  
  service_plan_id     = azurerm_service_plan.devflow-service-plan.id

  site_config {
    always_on = false
  }

  identity{
    type = "SystemAssigned"
  }

  app_settings = {
    "WEBSITE_RUN_FROM_PACKAGE" = "1"
    "ASPNETCORE_ENVIRONMENT" = "Production"
    "KeyVaultUrl": "${azurerm_key_vault.devflow_key_vault.vault_uri}"
  }
}

resource "azurerm_key_vault_access_policy" "devflow_key_vault_access_policy_app_service" {
  depends_on = [ azurerm_key_vault.devflow_key_vault, azurerm_windows_web_app.devflow-web-app ]
  key_vault_id = azurerm_key_vault.devflow_key_vault.id
  tenant_id    = data.azurerm_client_config.devflow_client_config.tenant_id
  object_id    = azurerm_windows_web_app.tech-integration-web-app.identity[0].principal_id
  key_permissions = var.devflow_key_vault_key_permissions
  secret_permissions = var.devflow_key_vault_secret_permissions
}