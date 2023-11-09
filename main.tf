
## sql-database


provider "azurerm" {
  features = {}
}

resource "azurerm_resource_group" "myapp" {
  name     = "myapp-resource-group"
  location = "East US"
}

resource "azurerm_sql_server" "myapp" {
  name                         = "myapp-sql-server"
  resource_group_name          = azurerm_resource_group.myapp.name
  location                     = azurerm_resource_group.myapp.location
  version                      = "12.0"
  administrator_login          = "sqladmin"
  administrator_login_password = "Password123!"
}

resource "azurerm_sql_database" "myapp" {
  name                = "myapp-sql-database"
  resource_group_name = azurerm_resource_group.myapp.name
  location            = azurerm_resource_group.myapp.location
  server_name         = azurerm_sql_server.myapp.name
  edition             = "Standard"
  collation           = "SQL_Latin1_General_CP1_CI_AS"
  max_size_gb         = 1
  requested_service_objective_id = "/subscriptions/<subscription_id>/resourceGroups/${azurerm_resource_group.myapp.name}/providers/Microsoft.Sql/servers/${azurerm_sql_server.myapp.name}/serviceObjectives/S0"
}

output "sql_server_fqdn" {
  value = azurerm_sql_server.myapp.fully_qualified_domain_name
}


provider "azurerm" {
  features = {}
}

resource "azurerm_resource_group" "myapp" {
  name     = "myapp-resource-group"
  location = "East US"
}



## web app service


resource "azurerm_app_service_plan" "myapp" {
  name                = "myapp-app-service-plan"
  resource_group_name = azurerm_resource_group.myapp.name
  location            = azurerm_resource_group.myapp.location

  sku {
    tier = "Basic"
    size = "B1"
  }
}

resource "azurerm_app_service" "myapp" {
  name                = "myapp-web-app"
  resource_group_name = azurerm_resource_group.myapp.name
  location            = azurerm_resource_group.myapp.location
  app_service_plan_id = azurerm_app_service_plan.myapp.id

  site_config {
    always_on = true

    app_settings = {
      "WEBSITE_NODE_DEFAULT_VERSION" = "14.17.0"
    }
  }
}

output "web_app_url" {
  value = azurerm_app_service.myapp.default_site_hostname
}
