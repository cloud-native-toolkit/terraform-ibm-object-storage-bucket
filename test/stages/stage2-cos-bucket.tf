module "dev_tools_cos_bucket" {
  source = "./module"

  resource_group_name = var.resource_group_name
  region              = var.region
  instance-region     = var.cos-instance-region
  instance-name       = var.cos-instance-name
  name                = var.cos-bucket-name
}
