resource "azurerm_resource_group" "rg" {
  name     = "rgHAMSTER"
  location = "southcentralus"
}

resource "azurerm_storage_account" "sa" {
  name                     = "sahamster"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "Storage"
  min_tls_version          = "TLS1_2"
}

resource "azurerm_service_plan" "asp" {
  name                = "aspHAMSTER"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  os_type             = "Linux"
  sku_name            = "B1"
}

resource "azurerm_linux_function_app" "af" {
  name                        = "faHAMSTER"
  resource_group_name         = azurerm_resource_group.rg.name
  location                    = azurerm_resource_group.rg.location
  service_plan_id             = azurerm_service_plan.asp.id
  storage_account_name        = azurerm_storage_account.sa.name
  storage_account_access_key  = azurerm_storage_account.sa.primary_access_key


  identity {
    type = "SystemAssigned"
  }

  site_config {
    application_stack {
      python_version = 3.9
    }
  }
}

resource "azurerm_api_management" "apim" {
  name                = "apimHAMSTER"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  publisher_name      = "Justin L. Brown"
  publisher_email     = "JustinLBrown@JustinLBrown.onmicrosoft.com"

  sku_name = "Consumption_0"
}