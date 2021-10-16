module "cos" {
  source = "github.com/ibm-garage-cloud/terraform-ibm-object-storage.git"

  ibmcloud_api_key    = var.ibmcloud_api_key
  resource_group_name = var.resource_group_name
  name_prefix         = var.name_prefix
  name                = "test-cos-instance"
  provision = true
}
