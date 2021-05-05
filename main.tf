resource null_resource print_names {
  provisioner "local-exec" {
    command = "echo 'Resource group: ${var.resource_group_name}'"
  }
}

data ibm_resource_group resource_group {
  depends_on = [null_resource.print_names]

  name = var.resource_group_name
}

locals {
  prefix_name       = var.name_prefix != "" ? var.name_prefix : var.resource_group_name
  bucket_name       = lower(replace(var.name != "" ? var.name : "${var.resource_group_name}-cos-bucket", "_", "-"))
}

resource ibm_cos_bucket bucket_instance {
  count                   = (var.provision ? 1 : 0)

  bucket_name             = local.bucket_name
  resource_instance_id    = var.cos_instance_id
  region_location         = var.region
  storage_class           = var.storage_class
  key_protect             = var.kms_key_crn
}
