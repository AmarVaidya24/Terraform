resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

########################################################################
# Hub virtual network
########################################################################
resource "azurerm_virtual_network" "hub" {
  name                = "${var.prefix}-hub-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet" "appgw" {
  name                 = "AppGatewaySubnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.hub.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_subnet" "gateway" {
  name                 = "GatewaySubnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.hub.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_public_ip" "appgw_pip" {
  name                = "${var.prefix}-appgw-pip"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_public_ip" "vpn_pip" {
  name                = "${var.prefix}-vpn-pip"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Dynamic"
  sku                 = "Basic"
}

########################################################################
# Application Gateway (minimal example)
########################################################################
resource "azurerm_application_gateway" "appgw" {
  name                = "${var.prefix}-appgw"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location

  sku {
    name     = "Standard_v2"
    tier     = "Standard_v2"
    capacity = 2
  }

  gateway_ip_configuration {
    name      = "appgw_ipcfg"
    subnet_id = azurerm_subnet.appgw.id
  }

  frontend_port {
    name = "frontendPort"
    port = 80
  }

  frontend_ip_configuration {
    name                 = "appgw_frontend_ip"
    public_ip_address_id = azurerm_public_ip.appgw_pip.id
  }

  backend_address_pool {
    name = "defaultbackend"
  }

  backend_http_settings {
    name                  = "backend_http_settings"
    cookie_based_affinity = "Disabled"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 30
  }

  http_listener {
    name                           = "http_listener"
    frontend_ip_configuration_name = "appgw_frontend_ip"
    frontend_port_name             = "frontendPort"
    protocol                       = "Http"
  }

  request_routing_rule {
    name                       = "rule1"
    rule_type                  = "Basic"
    http_listener_name         = "http_listener"
    backend_address_pool_name  = "defaultbackend"
    backend_http_settings_name = "backend_http_settings"
  }
}

########################################################################
# Virtual Network Gateway (VPN)
########################################################################
resource "azurerm_virtual_network_gateway" "vpngw" {
  name                = "${var.prefix}-vpngw"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  type     = "Vpn"
  vpn_type = "RouteBased"
  sku      = "VpnGw1"

  ip_configuration {
    name                 = "vnetGatewayConfig"
    public_ip_address_id = azurerm_public_ip.vpn_pip.id
    subnet_id            = azurerm_subnet.gateway.id
  }
}

########################################################################
# Spoke VNets: Prod and Test
########################################################################
resource "azurerm_virtual_network" "prod" {
  name                = "${var.prefix}-prod-spoke"
  address_space       = ["10.1.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet" "prod_frontend" {
  name                 = "frontend"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.prod.name
  address_prefixes     = ["10.1.1.0/24"]
}

resource "azurerm_subnet" "prod_backend" {
  name                 = "backend"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.prod.name
  address_prefixes     = ["10.1.2.0/24"]
}

resource "azurerm_virtual_network" "test" {
  name                = "${var.prefix}-test-spoke"
  address_space       = ["10.2.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet" "test_frontend" {
  name                 = "frontend"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.test.name
  address_prefixes     = ["10.2.1.0/24"]
}

resource "azurerm_subnet" "test_backend" {
  name                 = "backend"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.test.name
  address_prefixes     = ["10.2.2.0/24"]
}

########################################################################
# VNet peerings (hub <-> spokes)
########################################################################
resource "azurerm_virtual_network_peering" "hub_to_prod" {
  name                         = "hub-to-prod"
  resource_group_name          = azurerm_resource_group.rg.name
  virtual_network_name         = azurerm_virtual_network.hub.name
  remote_virtual_network_id    = azurerm_virtual_network.prod.id
  allow_forwarded_traffic      = true
  allow_gateway_transit        = true
  allow_virtual_network_access = true
}

resource "azurerm_virtual_network_peering" "prod_to_hub" {
  name                         = "prod-to-hub"
  resource_group_name          = azurerm_resource_group.rg.name
  virtual_network_name         = azurerm_virtual_network.prod.name
  remote_virtual_network_id    = azurerm_virtual_network.hub.id
  allow_forwarded_traffic      = true
  use_remote_gateways          = false
  allow_virtual_network_access = true
}

resource "azurerm_virtual_network_peering" "hub_to_test" {
  name                         = "hub-to-test"
  resource_group_name          = azurerm_resource_group.rg.name
  virtual_network_name         = azurerm_virtual_network.hub.name
  remote_virtual_network_id    = azurerm_virtual_network.test.id
  allow_forwarded_traffic      = true
  allow_gateway_transit        = true
  allow_virtual_network_access = true
}

resource "azurerm_virtual_network_peering" "test_to_hub" {
  name                         = "test-to-hub"
  resource_group_name          = azurerm_resource_group.rg.name
  virtual_network_name         = azurerm_virtual_network.test.name
  remote_virtual_network_id    = azurerm_virtual_network.hub.id
  allow_forwarded_traffic      = true
  use_remote_gateways          = false
  allow_virtual_network_access = true
}

########################################################################
# Network Security Groups for subnets (minimal rules)
########################################################################
resource "azurerm_network_security_group" "frontend_nsg" {
  name                = "${var.prefix}-frontend-nsg"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_network_security_group" "backend_nsg" {
  name                = "${var.prefix}-backend-nsg"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet_network_security_group_association" "prod_frontend_assoc" {
  subnet_id                 = azurerm_subnet.prod_frontend.id
  network_security_group_id = azurerm_network_security_group.frontend_nsg.id
}

resource "azurerm_subnet_network_security_group_association" "prod_backend_assoc" {
  subnet_id                 = azurerm_subnet.prod_backend.id
  network_security_group_id = azurerm_network_security_group.backend_nsg.id
}

resource "azurerm_subnet_network_security_group_association" "test_frontend_assoc" {
  subnet_id                 = azurerm_subnet.test_frontend.id
  network_security_group_id = azurerm_network_security_group.frontend_nsg.id
}

resource "azurerm_subnet_network_security_group_association" "test_backend_assoc" {
  subnet_id                 = azurerm_subnet.test_backend.id
  network_security_group_id = azurerm_network_security_group.backend_nsg.id
}

# Allow traffic from Application Gateway (hub AppGatewaySubnet) to frontends on 80/443
resource "azurerm_network_security_rule" "allow_appgw_to_frontend" {
  name                        = "Allow-AppGw-To-Frontend"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_ranges     = ["80", "443"]
  source_address_prefix       = azurerm_subnet.appgw.address_prefixes[0]
  destination_address_prefix  = "*"
  network_security_group_name = azurerm_network_security_group.frontend_nsg.name
  resource_group_name         = azurerm_resource_group.rg.name
}

# Allow traffic from frontend subnets to backend subnets (APIs between frontend and backend)
resource "azurerm_network_security_rule" "allow_frontend_to_backend_prod" {
  name                        = "Allow-Frontend-To-Backend-Prod"
  priority                    = 110
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_ranges     = ["80", "443"]
  source_address_prefix       = azurerm_subnet.prod_frontend.address_prefixes[0]
  destination_address_prefix  = "*"
  network_security_group_name = azurerm_network_security_group.backend_nsg.name
  resource_group_name         = azurerm_resource_group.rg.name
}

resource "azurerm_network_security_rule" "allow_frontend_to_backend_test" {
  name                        = "Allow-Frontend-To-Backend-Test"
  priority                    = 120
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_ranges     = ["80", "443"]
  source_address_prefix       = azurerm_subnet.test_frontend.address_prefixes[0]
  destination_address_prefix  = "*"
  network_security_group_name = azurerm_network_security_group.backend_nsg.name
  resource_group_name         = azurerm_resource_group.rg.name
}

/* Optional: allow backend outbound to SQL over 1433 (explicit outbound allow)
   Azure NSGs allow outbound by default, but adding an explicit rule restricts to SQL port.
*/
resource "azurerm_network_security_rule" "allow_backend_to_sql" {
  name                        = "Allow-Backend-To-SQL"
  priority                    = 200
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "1433"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  network_security_group_name = azurerm_network_security_group.backend_nsg.name
  resource_group_name         = azurerm_resource_group.rg.name
}

########################################################################
# Azure SQL Server + Database (example)
########################################################################
resource "azurerm_sql_server" "sql" {
  name                         = "${var.prefix}-sqlsrv"
  resource_group_name          = azurerm_resource_group.rg.name
  location                     = azurerm_resource_group.rg.location
  version                      = "12.0"
  administrator_login          = var.sql_admin
  administrator_login_password = var.sql_password
}

# Allow Azure services (including VNet resources) to access the SQL server
resource "azurerm_sql_firewall_rule" "allow_azure_services" {
  name                = "AllowAzureServices"
  resource_group_name = azurerm_resource_group.rg.name
  server_name         = azurerm_sql_server.sql.name
  start_ip_address    = "0.0.0.0"
  end_ip_address      = "0.0.0.0"
}

resource "azurerm_sql_database" "sqldb" {
  name                = "${var.prefix}-sqldb"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  server_name         = azurerm_sql_server.sql.name
  sku_name            = "Basic"
}
