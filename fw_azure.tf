# Configure the Microsoft Azure Provider
provider "azurerm" {
    version = "~> 1.35"

	subscription_id = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
    client_id       = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
    client_secret   = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
    tenant_id       = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"


}

provider "azurerm" {
    version = "~> 1.35"
    alias = "number2"

	subscription_id = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
    client_id       = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
    client_secret   = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
    tenant_id       = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
}

# Create a resource group if it does not exist
resource "azurerm_resource_group" "myterraformgroup" {
    name     = "myrg"
    location = "eastus"

    tags = {
        CreatedBy   = "SecOps"
        CreatedOn   =  formatdate("YYYY MM DD hh:mm ZZZ", timestamp()) 
    }
}

# Create Availability Set
resource "azurerm_availability_set" "myavailabilityset" {
  name                = "my-as"
  location            = "eastus"
  resource_group_name = "${azurerm_resource_group.myterraformgroup.name}"
  managed             = true

  tags = {
      CreatedBy   = "SecOps"
      CreatedOn   =  formatdate("YYYY MM DD hh:mm ZZZ", timestamp()) 
  }
}

# Create Network Security Group
resource "azurerm_network_security_group" "myterraformnsg" {
    name                = "Only-RFC-1918"
    location            = "eastus"
    resource_group_name = "${azurerm_resource_group.myterraformgroup.name}"
}
    
# Create Network Security rule
resource "azurerm_network_security_rule" "myterraformnsg1" {
        name                        = "Inbound-10"
        priority                    = 100
        direction                   = "Inbound"
        access                      = "Allow"
        protocol                    = "Tcp"
        source_port_range           = "*"
        destination_port_range      = "*"
        source_address_prefix       = "10.0.0.0/8"
        destination_address_prefix  = "*"
        resource_group_name         = "${azurerm_resource_group.myterraformgroup.name}"
        network_security_group_name = "${azurerm_network_security_group.myterraformnsg.name}"
}

# Create Network Security rule
resource "azurerm_network_security_rule" "myterraformnsg2" {
        name                        = "Inbound-172"
        priority                    = 110
        direction                   = "Inbound"
        access                      = "Allow"
        protocol                    = "Tcp"
        source_port_range           = "*"
        destination_port_range      = "*"
        source_address_prefix       = "172.16.0.0/12"
        destination_address_prefix  = "*"
        resource_group_name         = "${azurerm_resource_group.myterraformgroup.name}"
        network_security_group_name = "${azurerm_network_security_group.myterraformnsg.name}"
}

# Create Network Security rule
resource "azurerm_network_security_rule" "myterraformnsg3" {
        name                        = "Inbound-192"
        priority                    = 120
        direction                   = "Inbound"
        access                      = "Allow"
        protocol                    = "Tcp"
        source_port_range           = "*"
        destination_port_range      = "*"
        source_address_prefix       = "192.168.0.0/16"
        destination_address_prefix  = "*"
        resource_group_name         = "${azurerm_resource_group.myterraformgroup.name}"
        network_security_group_name = "${azurerm_network_security_group.myterraformnsg.name}"
}

# Create Network Security rule
resource "azurerm_network_security_rule" "myterraformnsg4" {
        name                        = "Outbound-10"
        priority                    = 100
        direction                   = "Outbound"
        access                      = "Allow"
        protocol                    = "Tcp"
        source_port_range           = "*"
        destination_port_range      = "*"
        source_address_prefix       = "*"
        destination_address_prefix  = "10.0.0.0/8"
        resource_group_name         = "${azurerm_resource_group.myterraformgroup.name}"
        network_security_group_name = "${azurerm_network_security_group.myterraformnsg.name}"
}

# Create Network Security rule
resource "azurerm_network_security_rule" "myterraformnsg5" {
        name                        = "Outbound-172"
        priority                    = 110
        direction                   = "Outbound"
        access                      = "Allow"
        protocol                    = "Tcp"
        source_port_range           = "*"
        destination_port_range      = "*"
        source_address_prefix       = "*"
        destination_address_prefix  = "172.16.0.0/12"
        resource_group_name         = "${azurerm_resource_group.myterraformgroup.name}"
        network_security_group_name = "${azurerm_network_security_group.myterraformnsg.name}"
}

# Create Network Security rule
resource "azurerm_network_security_rule" "myterraformnsg6" {
        name                        = "Outbound-192"
        priority                    = 120
        direction                   = "Outbound"
        access                      = "Allow"
        protocol                    = "Tcp"
        source_port_range           = "*"
        destination_port_range      = "*"
        source_address_prefix       = "*"
        destination_address_prefix  = "192.168.0.0/16"
        resource_group_name         = "${azurerm_resource_group.myterraformgroup.name}"
        network_security_group_name = "${azurerm_network_security_group.myterraformnsg.name}"
}

# Create virtual network
resource "azurerm_virtual_network" "myterraformnetwork" {
    name                = "my-vnet"
    address_space       = ["10.252.0.0/24"]
    location            = "eastus"
    resource_group_name = "${azurerm_resource_group.myterraformgroup.name}"

    tags = {
        CreatedBy   = "SecOps"
        CreatedOn   =  formatdate("YYYY MM DD hh:mm ZZZ", timestamp()) 
    }
}

# Create subnet1
resource "azurerm_subnet" "myterraformsubnetfwfront" {
    name                 = "firewall-frontend"
    resource_group_name  = "${azurerm_resource_group.myterraformgroup.name}"
    virtual_network_name = "${azurerm_virtual_network.myterraformnetwork.name}"
    address_prefix       = "10.252.0.0/27"
}

# Create subnet2
resource "azurerm_subnet" "myterraformsubnetfwback" {
    name                      = "firewall-backend"
    resource_group_name       = "${azurerm_resource_group.myterraformgroup.name}"
    virtual_network_name      = "${azurerm_virtual_network.myterraformnetwork.name}"
    address_prefix            = "10.252.0.32/27"
    network_security_group_id = "${azurerm_network_security_group.myterraformnsg.id}"
}

# Create subnet3
resource "azurerm_subnet" "myterraformsubnetfwmgmt" {
    name                      = "management"
    resource_group_name       = "${azurerm_resource_group.myterraformgroup.name}"
    virtual_network_name      = "${azurerm_virtual_network.myterraformnetwork.name}"
    address_prefix            = "10.252.0.64/26"
    network_security_group_id = "${azurerm_network_security_group.myterraformnsg.id}"
}

# Create GateWay Subnet
resource "azurerm_subnet" "myterraformsubnetgateway" {
  name                 = "GatewaySubnet"
  resource_group_name  = "${azurerm_resource_group.myterraformgroup.name}"
  virtual_network_name = "${azurerm_virtual_network.myterraformnetwork.name}"
  address_prefix       = "10.252.0.128/26"
}


# Create Subnet Security Group Association
#resource "azurerm_subnet_network_security_group_association" "myterraformsga1" {
#  subnet_id                 = "${azurerm_subnet.myterraformsubnetfwback.id}"
#  network_security_group_id = "${azurerm_network_security_group.myterraformnsg.id}"
#}

# Create Subnet Security Group Association
#resource "azurerm_subnet_network_security_group_association" "myterraformsga2" {
#  subnet_id                 = "${azurerm_subnet.myterraformsubnetfwmgmt.id}"
#  network_security_group_id = "${azurerm_network_security_group.myterraformnsg.id}"
#}

# Create Route Table
resource "azurerm_route_table" "myterraformroutetable"{
  name                          = "Global-General"
  location                      = "eastus"
  resource_group_name           = "${azurerm_resource_group.myterraformgroup.name}"
  disable_bgp_route_propagation = false

  tags = {
    CreatedBy   = "SecOps"
    CreatedOn   =  formatdate("YYYY MM DD hh:mm ZZZ", timestamp()) 
  }
}       
        
# Create Internet Route             
resource "azurerm_route" "myterraformroute1" {
  name                   = "ToInternet"
  resource_group_name    = "${azurerm_resource_group.myterraformgroup.name}"
  route_table_name       = "${azurerm_route_table.myterraformroutetable.name}"
  address_prefix         = "0.0.0.0/0"
  next_hop_type          = "virtualappliance"
  next_hop_in_ip_address = "10.252.0.39"
}       

# Create Local vNet Route
resource "azurerm_route" "myterraformroute2" {
  name                   = "VNETLocal"
  resource_group_name    = "${azurerm_resource_group.myterraformgroup.name}"
  route_table_name       = "${azurerm_route_table.myterraformroutetable.name}"
  address_prefix         = "10.252.0.0/25"
  next_hop_type          = "vnetlocal"
}       

# Create FW1 1st public IP
resource "azurerm_public_ip" "myterraformpublicipfw1" {
    name                         = "my-fw1-pip"
    location                     = "eastus"
    resource_group_name          = "${azurerm_resource_group.myterraformgroup.name}"
    allocation_method            = "Static"

    tags = {
        CreatedBy   = "SecOps"
        CreatedOn   =  formatdate("YYYY MM DD hh:mm ZZZ", timestamp()) 
    }
}

# Create FW2 1st public IP
resource "azurerm_public_ip" "myterraformpublicipfw2" {
    name                         = "my-fw2-pip"
    location                     = "eastus"
    resource_group_name          = "${azurerm_resource_group.myterraformgroup.name}"
    allocation_method            = "Static"

    tags = {
        CreatedBy   = "SecOps"
        CreatedOn   =  formatdate("YYYY MM DD hh:mm ZZZ", timestamp()) 
    }
}

# Create Azure VPN public IP
resource "azurerm_public_ip" "myterraformpublicipazvpn" {
    name                         = "my-vpn-pip"
    location                     = "eastus"
    resource_group_name          = "${azurerm_resource_group.myterraformgroup.name}"
    allocation_method            = "Dynamic"

    tags = {
        CreatedBy   = "SecOps"
        CreatedOn   =  formatdate("YYYY MM DD hh:mm ZZZ", timestamp()) 
    }
}

# Create fw1 network interface1
resource "azurerm_network_interface" "myterraformnicfw1nic1" {
    name                      = "my-fw1-nic1"
    location                  = "eastus"
    resource_group_name       = "${azurerm_resource_group.myterraformgroup.name}"

    ip_configuration {
        name                          = "myNicConfiguration"
        subnet_id                     = "${azurerm_subnet.myterraformsubnetfwback.id}"
        private_ip_address_allocation = "Static"
        private_ip_address            = "10.252.0.39"
    }

    tags = {
        CreatedBy   = "SecOps"
        CreatedOn   =  formatdate("YYYY MM DD hh:mm ZZZ", timestamp()) 
    }
}

# Create fw1 network interface2
resource "azurerm_network_interface" "myterraformnicfw1nic2" {
    name                      = "my-fw1-nic2"
    location                  = "eastus"
    resource_group_name       = "${azurerm_resource_group.myterraformgroup.name}"

    ip_configuration {
        name                          = "myNicConfiguration"
        subnet_id                     = "${azurerm_subnet.myterraformsubnetfwfront.id}"
        private_ip_address_allocation = "Static"
        private_ip_address            = "10.252.0.7"
        public_ip_address_id          = "${azurerm_public_ip.myterraformpublicipfw1.id}"
    }

    tags = {
        CreatedBy   = "SecOps"
        CreatedOn   =  formatdate("YYYY MM DD hh:mm ZZZ", timestamp()) 
    }
}


# Create fw2 network interface1
resource "azurerm_network_interface" "myterraformnicfw2nic1" {
    name                      = "my-fw2-nic1"
    location                  = "eastus"
    resource_group_name       = "${azurerm_resource_group.myterraformgroup.name}"

    ip_configuration {
        name                          = "myNicConfiguration"
        subnet_id                     = "${azurerm_subnet.myterraformsubnetfwback.id}"
        private_ip_address_allocation = "Static"
        private_ip_address            = "10.252.0.40"
    }

    tags = {
        CreatedBy   = "SecOps"
        CreatedOn   =  formatdate("YYYY MM DD hh:mm ZZZ", timestamp()) 
    }
}

# Create fw2 network interface2
resource "azurerm_network_interface" "myterraformnicfw2nic2" {
    name                      = "my-fw2-nic2"
    location                  = "eastus"
    resource_group_name       = "${azurerm_resource_group.myterraformgroup.name}"

    ip_configuration {
        name                          = "myNicConfiguration"
        subnet_id                     = "${azurerm_subnet.myterraformsubnetfwfront.id}"
        private_ip_address_allocation = "Static"
        private_ip_address            = "10.252.0.8"
        public_ip_address_id          = "${azurerm_public_ip.myterraformpublicipfw2.id}"
    }

    tags = {
        CreatedBy   = "SecOps"
        CreatedOn   =  formatdate("YYYY MM DD hh:mm ZZZ", timestamp()) 
    }
}

# Create redhat idm network interface
resource "azurerm_network_interface" "myterraformnicipanic1" {
    name                      = "my-ident-nic"
    location                  = "eastus"
    resource_group_name       = "${azurerm_resource_group.myterraformgroup.name}"

    ip_configuration {
        name                          = "myNicConfiguration"
        subnet_id                     = "${azurerm_subnet.myterraformsubnetfwmgmt.id}"
        private_ip_address_allocation = "Static"
        private_ip_address            = "10.252.0.71"
    }

    tags = {
        CreatedBy   = "SecOps"
        CreatedOn   =  formatdate("YYYY MM DD hh:mm ZZZ", timestamp()) 
    }
}

# Create sftp network interface2
resource "azurerm_network_interface" "myterraformnicsftpnic1" {
    name                      = "my-sftp-nic"
    location                  = "eastus"
    resource_group_name       = "${azurerm_resource_group.myterraformgroup.name}"

    ip_configuration {
        name                          = "myNicConfiguration"
        subnet_id                     = "${azurerm_subnet.myterraformsubnetfwmgmt.id}"
        private_ip_address_allocation = "Static"
        private_ip_address            = "10.252.0.75"
    }

    tags = {
        CreatedBy   = "SecOps"
        CreatedOn   =  formatdate("YYYY MM DD hh:mm ZZZ", timestamp())
    }
}

# Generate random text for a unique storage account name
resource "random_id" "randomId" {
    keepers = {
        # Generate a new ID only when a new resource group is defined
        resource_group = "${azurerm_resource_group.myterraformgroup.name}"
    }
    
    byte_length = 8
}

# Create storage account for boot diagnostics
resource "azurerm_storage_account" "mystorageaccount" {
    name                        = "diag${random_id.randomId.hex}"
    resource_group_name         = "${azurerm_resource_group.myterraformgroup.name}"
    location                    = "eastus"
    account_tier                = "Standard"
    account_replication_type    = "LRS"

    tags = {
        CreatedBy   = "SecOps"
        CreatedOn   =  formatdate("YYYY MM DD hh:mm ZZZ", timestamp()) 
    }
}

# Create Azure VPN Gateway
resource "azurerm_virtual_network_gateway" "myterraformazvpn" {
  name                = "my-vpn"
  location            = "eastus"
  resource_group_name = "${azurerm_resource_group.myterraformgroup.name}"

  type     = "Vpn"
  vpn_type = "RouteBased"

  active_active = false
  enable_bgp    = false
  sku           = "VpnGw1"

  ip_configuration {
    name                          = "vnetGatewayConfig"
    public_ip_address_id          = "${azurerm_public_ip.myterraformpublicipazvpn.id}"
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = "${azurerm_subnet.myterraformsubnetgateway.id}"
  }

  vpn_client_configuration {
    address_space = ["172.16.252.0/24"]

    root_certificate {
      name = "secops_CARoot_tmp"

      public_cert_data = <<EOF
	  
MIIDjzCCAnegAwIBAgIUYipO0JeNy0PRkQ3cTNy5qrhQHYUwDQYJKoZIhvcNAQEL
BQAwVzELMAkGA1UEBhMCVVMxCzAJBgNVBAgMAk5ZMREwDwYDVQQHDAhOZXcgWW9y
azERMA8GA1UECgwIQWNtZSBDby4xFTATBgNVBAMMDEFjbWUgQ29tcGFueTAeFw0x
OTEwMDcxMjI1MjhaFw0zOTEwMDIxMjI1MjhaMFcxCzAJBgNVBAYTAlVTMQswCQYD
VQQIDAJOWTERMA8GA1UEBwwITmV3IFlvcmsxETAPBgNVBAoMCEFjbWUgQ28uMRUw
EwYDVQQDDAxBY21lIENvbXBhbnkwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEK
AoIBAQDR0S16oKIwrye7aMfJ/KNAzbz+GVMM1/2FLU7i4KVIRi89Yr2XfGaB4xMU
GxCRsecxt9z1BAgcw9UD1GBfAqXlvem9EylfBhpoH4c1OdvPSWOZA9YLr17rm1Gy
ehn0pNNlHzmFb1V90EPJajHsTG8UdKwDGHYmYf3JOt6o900Hs7qdcEUL3rwn6hWG
QDlmWac6VGhlpL6RdDbzLiQmhAhoiaWM3iZJWyLzqJKX1kb7tCeIh+LyDsmWR7O1
6w9YB6eF65gbEdpRvDBk8Ocr5D45LmeMRxHYiCcXWZIor86mTZHY8oB5RdXN3SQU
sIICQn/BDw/MWfvzbLCnG9xtGXiLAgMBAAGjUzBRMB0GA1UdDgQWBBT9VxMvvWOg
W1y02vUiu0m6AZsG/jAfBgNVHSMEGDAWgBT9VxMvvWOgW1y02vUiu0m6AZsG/jAP
BgNVHRMBAf8EBTADAQH/MA0GCSqGSIb3DQEBCwUAA4IBAQB81aiRd8fB3QS3+5RZ
tMmeODcYhXcEJKTj5QgkAigvhBnts6b6DgBu06pU3QCQMhRZU01wFevVRNZPUTg7
xhe+4/U8QXGyU7SAY6nwxYuSyz2AsmVwagoOdGPJDSz0OjmiOSbECEk7/VPln3H3
x0nuZIhWHoWtve+6KaDNQIoiGBy0gaQcNK/rRBIllS+6L5uZReT/NUmzkvsVy79n
7dRfohgkrDCwQV84dy4IKzqJ5HY/jWb+6nNtypMWj0dCIt7htyBvZ4UIJqSEFJU7
F3/ovE6AzS+h/JO+Oc3589TyIq98c9wST4UtgcSGpcMrA12Rk9HCGBRJaj+6C3Iu
b55M
EOF
    }

  }
}

# Generate random text for a unique password
resource "random_password" "password" {
  length = 16
  special = true
  override_special = "_%@"
}

# Create FW1 virtual machine
resource "azurerm_virtual_machine" "myterraformvm1" {
    name                         = "my-fw1"
    location                     = "eastus"
    resource_group_name          = "${azurerm_resource_group.myterraformgroup.name}"
    network_interface_ids        = ["${azurerm_network_interface.myterraformnicfw1nic1.id}",
                                     "${azurerm_network_interface.myterraformnicfw1nic2.id}"]
    primary_network_interface_id = "${azurerm_network_interface.myterraformnicfw1nic1.id}"
    vm_size                      = "Standard_D2s_v3"
    availability_set_id          = "${azurerm_availability_set.myavailabilityset.id}"

    storage_os_disk {
        name              = "my-fw1-Disk"
        caching           = "ReadWrite"
        create_option     = "FromImage"
        managed_disk_type = "Premium_LRS"
    }

    storage_image_reference {
        publisher = "MicrosoftOSTC"
        offer     = "FreeBSD"
        sku       = "11.2"
        version   = "latest"
    }

    os_profile {
        computer_name  = "my-fw1"
        admin_username = "secops"
        admin_password = random_password.password.result
    }

    os_profile_linux_config {
        disable_password_authentication = false
    }

    boot_diagnostics {
        enabled = "true"
        storage_uri = "${azurerm_storage_account.mystorageaccount.primary_blob_endpoint}"
    }

    tags = {
        CreatedBy   = "SecOps"
        CreatedOn   =  formatdate("YYYY MM DD hh:mm ZZZ", timestamp()) 
    }
}

# Create FW2 virtual machine
resource "azurerm_virtual_machine" "myterraformvm2" {
    name                         = "my-fw2"
    location                     = "eastus"
    resource_group_name          = "${azurerm_resource_group.myterraformgroup.name}"
    network_interface_ids        = ["${azurerm_network_interface.myterraformnicfw2nic1.id}",
                                     "${azurerm_network_interface.myterraformnicfw2nic2.id}"]
    primary_network_interface_id = "${azurerm_network_interface.myterraformnicfw2nic1.id}"
    vm_size                      = "Standard_D2s_v3"
    availability_set_id          = "${azurerm_availability_set.myavailabilityset.id}"

    storage_os_disk {
        name              = "my-fw2-Disk"
        caching           = "ReadWrite"
        create_option     = "FromImage"
        managed_disk_type = "Premium_LRS"
    }

    storage_image_reference {
        publisher = "MicrosoftOSTC"
        offer     = "FreeBSD"
        sku       = "11.2"
        version   = "latest"
    }

    os_profile {
        computer_name  = "my-fw2"
        admin_username = "secops"
        admin_password = random_password.password.result
    }

    os_profile_linux_config {
        disable_password_authentication = false
    }

    boot_diagnostics {
        enabled = "true"
        storage_uri = "${azurerm_storage_account.mystorageaccount.primary_blob_endpoint}"
    }

    tags = {
        CreatedBy   = "SecOps"
        CreatedOn   =  formatdate("YYYY MM DD hh:mm ZZZ", timestamp()) 
    }
}

# Create redhat idm virtual machine
resource "azurerm_virtual_machine" "myterraformvm3" {
    name                         = "my-ident"
    location                     = "eastus"
    resource_group_name          = "${azurerm_resource_group.myterraformgroup.name}"
    network_interface_ids        = ["${azurerm_network_interface.myterraformnicipanic1.id}"]
    vm_size                      = "Standard_D4s_v3"
    availability_set_id          = "${azurerm_availability_set.myavailabilityset.id}"

    storage_os_disk {
        name              = "my-ident-Disk"
        caching           = "ReadWrite"
        create_option     = "FromImage"
        managed_disk_type = "Premium_LRS"
    }

    storage_image_reference {
        publisher = "RedHat"
        offer     = "RHEL"
        sku       = "7-RAW"
        version   = "latest"
    }

    os_profile {
        computer_name  = "ipa"
        admin_username = "secops"
        admin_password = random_password.password.result
    }

    os_profile_linux_config {
        disable_password_authentication = false
    }

    boot_diagnostics {
        enabled = "true"
        storage_uri = "${azurerm_storage_account.mystorageaccount.primary_blob_endpoint}"
    }

    tags = {
        CreatedBy   = "SecOps"
        CreatedOn   =  formatdate("YYYY MM DD hh:mm ZZZ", timestamp()) 
    }
}

# Create sftp virtual machine
resource "azurerm_virtual_machine" "myterraformvm4" {
    name                         = "my-sftp"
    location                     = "eastus"
    resource_group_name          = "${azurerm_resource_group.myterraformgroup.name}"
    network_interface_ids        = ["${azurerm_network_interface.myterraformnicsftpnic1.id}"]
    vm_size                      = "Standard_D2s_v3"
    availability_set_id          = "${azurerm_availability_set.myavailabilityset.id}"

    storage_os_disk {
        name              = "my-sftp-Disk"
        caching           = "ReadWrite"
        create_option     = "FromImage"
        managed_disk_type = "Premium_LRS"
        disk_size_gb      = "128"
    }

    storage_image_reference {
        publisher = "Canonical"
        offer     = "UbuntuServer"
        sku       = "18.04-LTS"
        version   = "latest"
    }

    os_profile {
        computer_name  = "sftp"
        admin_username = "secops"
        admin_password = random_password.password.result
    }

    os_profile_linux_config {
        disable_password_authentication = false
    }

    boot_diagnostics {
        enabled = "true"
        storage_uri = "${azurerm_storage_account.mystorageaccount.primary_blob_endpoint}"
    }

    tags = {
        CreatedBy   = "SecOps"
        CreatedOn   =  formatdate("YYYY MM DD hh:mm ZZZ", timestamp()) 
    }
}


#Add vNET Peering to connect existing networks behind firewall network

#data "azurerm_virtual_network" "myterraformvnet2" {
#  name                = "myvnet2"
#  resource_group_name = "my-rg2"
#  provider            = "azurerm.number2"
#}

#data "azurerm_virtual_network" "myterraformvnet2" {
#  name                = "${azurerm_virtual_network.myterraformnetwork.name}"
#  resource_group_name = "${azurerm_resource_group.myterraformgroup.name}"
#}

#resource "azurerm_virtual_network_peering" "myvnet2-to-myvnet1" {
#  name                         = "myvnet2-myvnet1-peer"
#  resource_group_name          = "${data.azurerm_virtual_network.securityvnet.resource_group_name}"
#  virtual_network_name         = "${data.azurerm_virtual_network.securityvnet.name}"
#  remote_virtual_network_id    = "${data.azurerm_virtual_network.amerenvnet.id}"
#  allow_virtual_network_access = true
#  allow_forwarded_traffic      = true
#  allow_gateway_transit        = true
#  provider                     = "azurerm.number2"
#}

#resource "azurerm_virtual_network_peering" "myvnet1-to-myvnet2" {
#  name                         = "myvnet1-myvnet2-peer"
#  resource_group_name          = "${data.azurerm_virtual_network.amerenvnet.resource_group_name}"
#  virtual_network_name         = "${data.azurerm_virtual_network.amerenvnet.name}"
#  remote_virtual_network_id    = "${data.azurerm_virtual_network.securityvnet.id}"
#  allow_virtual_network_access = true
#  allow_forwarded_traffic      = true
#  use_remote_gateways          = true
#}
