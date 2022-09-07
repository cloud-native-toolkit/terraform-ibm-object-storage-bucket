module "cos" {
  source = "github.com/ibm-garage-cloud/terraform-ibm-object-storage.git"

  resource_group_name = module.resource_group.name
  name_prefix         = var.name_prefix
  name                = "test-cos-instance"
  provision = true
}
