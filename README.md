# terraform-ibm-object-storage-bucket

Provisions an IBM Cloud Object Storage instance and creates a COS bucket


## Software dependencies

The module depends on the following software components:

### Command-line tools

- terraform - v13

### Terraform providers

- IBM Cloud provider >= 1.22.0

## Module dependencies

- Resource group - github.com/cloud-native-toolkit/terraform-ibm-resource-group.git
- Object storage - github.com/ibm-garage-cloud/terraform-ibm-object-storage.git

## Example usage

```hcl-terraform
module "dev_cos" {
  source = "./module"

  resource_group_name = module.resource_group.name
  name_prefix         = var.name_prefix
  ibmcloud_api_key    = var.ibmcloud_api_key
}
```

## Attribution

This work is derivative from https://github.com/terraform-ibm-modules/terraform-ibm-cos/tree/master/modules/bucket
