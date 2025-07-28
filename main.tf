resource "azurerm_resource_group" "main" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_storage_account" "static_site" {
  name                     = var.storage_account_name
  resource_group_name      = azurerm_resource_group.main.name
  location                 = azurerm_resource_group.main.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  #enable_https_traffic_only = true (sürüm sorunu)

  static_website {
    index_document = var.index_document
  }

  tags = {
    environment = "demo"
  }
}

resource "azurerm_cdn_profile" "cdn_profile" {
  name                = var.cdn_profile_name
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  sku                 = "Standard_Microsoft"
}

resource "azurerm_cdn_endpoint" "cdn_endpoint" {
  name                = var.cdn_endpoint_name
  profile_name        = azurerm_cdn_profile.cdn_profile.name
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  is_http_allowed     = true
  is_https_allowed    = true
  origin_host_header  = azurerm_storage_account.static_site.primary_web_host
  origin_path         = "/"
  content_types_to_compress = [
    "text/html",
    "text/css",
    "application/javascript",
    "application/json",
    "image/svg+xml"
  ]
  origin {
    name      = "staticweborigin"
    host_name = azurerm_storage_account.static_site.primary_web_host
    http_port = 80
    https_port = 443
  }

  /*delivery_rule {
    name = "EnforceHttps"
    order = 1

    actions {
      name = "UrlRedirect"
      parameters {
        redirect_type = "Found"
        protocol      = "Https"
      }
    }

    conditions {
      name = "RequestScheme"
      parameters {
        match_values = ["HTTP"]
        operator     = "Equal"
        negate_condition = false
        transforms = []
      }
    }
  }*/
}

resource "azurerm_app_service_plan" "function_app_plan" {
  name                = "my-function-app-plan"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  kind                = "FunctionApp"
  reserved            = true

  sku {
    tier = "Dynamic"
    size = "Y1"
  }
}

resource "azurerm_linux_function_app" "function_app" {
  name                       = "my-function-app-${random_integer.rand.result}"
  location                   = azurerm_resource_group.rg.location
  resource_group_name        = azurerm_resource_group.rg.name
  service_plan_id            = azurerm_app_service_plan.function_app_plan.id
  storage_account_name       = azurerm_storage_account.storage.name
  storage_account_access_key = azurerm_storage_account.storage.primary_access_key
  version                    = "~4"
  https_only                 = true

  site_config {
    application_stack {
      node_version = "18"
    }
  }

  identity {
    type = "SystemAssigned"
  }
}




