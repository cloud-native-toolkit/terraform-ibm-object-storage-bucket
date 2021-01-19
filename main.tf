provider "ibm" {
  version = ">= 1.17.0"
}

data "ibm_resource_group" "resource_group" {
  name = var.resource_group_name
}

data "ibm_resource_instance" "cos_instance" {
  name     = var.instance-name
  location = var.instance-region
  resource_group_id = data.ibm_resource_group.resource_group.id
}

resource "ibm_cos_bucket" "bucket" {
  bucket_name          = var.name
  resource_instance_id = data.ibm_resource_instance.cos_instance
  region_location      = var.region
  storage_class        = var.storage-class
}
