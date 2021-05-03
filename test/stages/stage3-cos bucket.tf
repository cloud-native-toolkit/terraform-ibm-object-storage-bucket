resource null_resource print_cos_id {
  depends_on = [module.cos.id]
  provisioner "local-exec" {
    command = "echo 'Provisioning bucket into COS instance: ${module.cos.id}'"
  }
}

resource "random_string" "random" {
  length           = 4
  special          = false
}

module "dev_cos_bucket" {
  source = "./module"

  resource_group_name = module.resource_group.name
  cos_instance_id     = module.cos.id
  name_prefix         = var.name_prefix
  ibmcloud_api_key    = var.ibmcloud_api_key
  name                = "my-test-bucket-${random_string.random.result}"
  region              = var.region
}
