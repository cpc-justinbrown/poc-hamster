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

  network_rules {
    default_action             = "Deny"
    ip_rules                   = ["64.129.107.15"]
  }

  routing {
    choice = "MicrosoftRouting"
    publish_microsoft_endpoints = true
  }
}

resource "azurerm_service_plan" "asp" {
  name                = "aspHAMSTER"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  os_type             = "Linux"
  sku_name            = "F1"
}

resource "azurerm_linux_function_app" "af" {
  name                = "faHAMSTER"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location

  storage_account_name = azurerm_storage_account.sa.name
  service_plan_id      = azurerm_service_plan.asp.id

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