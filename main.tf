resource null_resource print_names {
  provisioner "local-exec" {
    command = "echo 'Resource group: ${var.resource_group_name}'"
  }
  provisioner "local-exec" {
    command = "echo 'KMS key crn: ${var.kms_key_crn != null ? var.kms_key_crn : ""}'"
  }
  provisioner "local-exec" {
    command = "echo 'COS instance id: ${var.cos_instance_id}'"
  }
}

locals {
  prefix_name       = var.name_prefix != "" ? var.name_prefix : var.resource_group_name
  bucket_name       = lower(replace(var.name != "" ? var.name : "${local.prefix_name}-${var.label}", "_", "-"))
}

resource ibm_cos_bucket bucket_instance {
  depends_on              = [null_resource.print_names]
  count                   = (var.provision ? 1 : 0)

  bucket_name          = local.bucket_name
  resource_instance_id = var.cos_instance_id
  region_location      = var.region
  storage_class        = var.storage_class
  key_protect          = var.kms_key_crn
}

data ibm_cos_bucket bucket_instance {
  depends_on = [ibm_cos_bucket.bucket_instance]

  bucket_name          = local.bucket_name
  resource_instance_id = var.cos_instance_id
//  storage_class        = var.storage_class
  bucket_type          = "region_location"
  bucket_region        = var.region
}
