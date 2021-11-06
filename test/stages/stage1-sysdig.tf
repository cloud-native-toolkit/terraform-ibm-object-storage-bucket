module "monitoring" {
  source = "github.com/cloud-native-toolkit/terraform-ibm-sysdig"

  resource_group_name      = module.resource_group.name
  region                   = var.region
  provision                = true
  name_prefix              = var.name_prefix
}
