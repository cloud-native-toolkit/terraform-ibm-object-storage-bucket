module "activity_tracker" {
  source = "github.com/cloud-native-toolkit/terraform-ibm-activity-tracker"

  resource_group_name = module.resource_group.name
  resource_location   = var.region
  provision           = false
}
