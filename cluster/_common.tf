
# Store terraform state in Azure
terraform {
  backend "azurerm" {
      resource_group_name  = "TerraformStateRG" # Change this
      storage_account_name = "anvilterraformstate" # Change this
      container_name       = "tfstate"
      key                  = "terraform.tfstate"
      #access_key           = "----" # Should come from az CLI automatically, or get from ARM_ACCESS_KEY:
                                     #     export ARM_ACCESS_KEY=$(az storage account keys list --resource-group TerraformStateRG --query '[0].value' -o tsv  --account-name anvilterraformstate)
  }
}

provider "azurerm" {
  features { }
}

locals {
  config = yamldecode(file("config.yml"))
}
