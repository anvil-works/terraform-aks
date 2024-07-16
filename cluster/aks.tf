resource "azurerm_resource_group" "this" {
  name     = local.config.resource_group
  location = local.config.location
}

resource "azurerm_kubernetes_cluster" "this" {
  name                = local.config.cluster.name
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  dns_prefix          = local.config.cluster.name
  kubernetes_version  = local.config.cluster.version

  default_node_pool {
    name       = "default"
    node_count = local.config.cluster.node_count
    vm_size    = local.config.cluster.vm_size
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {}

  provisioner "local-exec" {
    when = create
    command = "az aks get-credentials --resource-group ${self.resource_group_name} --name ${self.name} --overwrite-existing"
    on_failure = continue
  }
  provisioner "local-exec" {
    when = destroy
    command = "kubectl config unset current-context"
    on_failure = continue
  }
  provisioner "local-exec" {
    when = destroy
    command = "kubectl config delete-context ${self.name}"
    on_failure = continue
  }
  provisioner "local-exec" {
    when = destroy
    command = "kubectl config delete-cluster ${self.name}"
    on_failure = continue
  }
  provisioner "local-exec" {
    when = destroy
    command = "kubectl config delete-user clusterUser_${self.resource_group_name}_${self.name}"
    on_failure = continue
  }

}

output "client_certificate" {
  value     = azurerm_kubernetes_cluster.this.kube_config[0].client_certificate
  sensitive = true
}

output "kube_config" {
  value = azurerm_kubernetes_cluster.this.kube_config_raw

  sensitive = true
}