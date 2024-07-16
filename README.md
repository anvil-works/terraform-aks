# Anvil AKS Config

This directory contains a [Terraform](https://developer.hashicorp.com/terraform) configuration to help you provision a suitable [AKS cluster](https://aws.amazon.com/eks/) for [Anvil](https://anvil.works/docs/enterprise/kubernetes/aks).

## Provision the AKS Cluster

* Switch to the `cluster` directory
* Edit `_common.tf` to provide your own Azure Container in which to store the Terraform state. You will need to create this container manually through Azure.
* Edit `config.yml` to configure the cluster parameters
  * Edit the location and resource group to suit your requirements. This is where the AKS cluster will be created.
  * Give the cluster a `name`, `node_count`, and choose the `vm_size` of the nodes that should exist. We recommend starting with two or three `Standard_D2_v2` nodes - this can always be scaled up later.
* Run `terraform init`, then `terraform apply` to create the cluster. This will take a few minutes as AKS clusters and Nodes are slow to provision.
* Check that your local `kubectl` is configured to talk to the cluster by default. Test by running `kubectl get nodes`.
