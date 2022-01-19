provider "azurerm" {
  features {}
}


terraform {
    backend "azurerm" {
        resource_group_name  = "tf_rg_storage"
        storage_account_name = "tfstorageaccountgm"
        container_name       = "tfstate"
        key                  = "terraform.tfstate"
    }
}


resource "azurerm_resource_group" "example" {
  name     = "AKS-RG"
  location = "West Europe"
}

resource "azurerm_kubernetes_cluster" "example" {
  name                = "aks1"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  dns_prefix          = "aks1"

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_D2_v2"
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    Environment = "Test"
  }
}

output "client_certificate" {
  value = azurerm_kubernetes_cluster.example.kube_config.0.client_certificate
}

output "kube_config" {
  value = azurerm_kubernetes_cluster.example.kube_config_raw

  sensitive = true
}