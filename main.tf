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
  provisioner "local-exec" {
    command = "echo 'Activity Tracker crn: ${var.activity_tracker_crn != null ? var.activity_tracker_crn : ""}'"
  }
  provisioner "local-exec" {
    command = "echo 'Monitoring crn: ${var.metrics_monitoring_crn != null ? var.metrics_monitoring_crn : ""}'"
  }
}

locals {
  prefix_name   = var.name_prefix != "" ? var.name_prefix : var.resource_group_name
  bucket_name   = lower(replace(var.name != "" ? var.name : "${local.prefix_name}-${var.label}", "_", "-"))
  bucket_type   = var.cross_region_location != "" ?  "cross_region_location" : "region_location"
  bucket_region = local.bucket_type == "cross_region_location" ? var.cross_region_location : var.region
  vpc_ip_addresses = var.vpc_ip_addresses != null ? var.vpc_ip_addresses : []
  allowed_ip    = var.allowed_ip != null ? var.allowed_ip : []
  tmp_allowed_ips = concat(local.vpc_ip_addresses, local.allowed_ip)
  allowed_ips = var.vpc_ip_addresses == null && var.allowed_ip == null ? null : local.tmp_allowed_ips
}

resource ibm_cos_bucket bucket_instance {
  depends_on            = [null_resource.print_names]
  count                 = (var.provision ? 1 : 0)

  bucket_name           = local.bucket_name
  resource_instance_id  = var.cos_instance_id
  region_location       = local.bucket_type == "region_location" ? local.bucket_region : null
  cross_region_location = local.bucket_type == "cross_region_location" ? local.bucket_region : null
  storage_class         = var.storage_class
  key_protect           = var.kms_key_crn
  allowed_ip            = local.allowed_ips

  dynamic "activity_tracking" {
    for_each = var.activity_tracker_crn != null ? [var.activity_tracker_crn] : []

    content {
      read_data_events = true
      write_data_events = true
      activity_tracker_crn = activity_tracking.value
    }
  }

  dynamic "metrics_monitoring" {
    for_each = var.metrics_monitoring_crn != null ? [var.metrics_monitoring_crn] : []

    content {
      usage_metrics_enabled = true
      metrics_monitoring_crn = metrics_monitoring.value
    }
  }
}

data ibm_cos_bucket bucket_instance {
  depends_on = [ibm_cos_bucket.bucket_instance]

  bucket_name          = local.bucket_name
  resource_instance_id = var.cos_instance_id
  bucket_type          = local.bucket_type
  bucket_region        = local.bucket_region
}

resource "null_resource" "cos-contents-clean" {
  triggers = {    
    #namespace  = var.app_namespace
    bucket-name = local.bucket_name
    COS-S3-ENDPOINT = var.COS-S3-ENDPOINT
    ACCESS-KEY = var.ACCESS-KEY
    SECRET-KEY = var.SECRET-KEY

  }
  provisioner "local-exec" {
    when = destroy
    command = "./deleteCOS.sh ${self.triggers.bucket-name} ${self.triggers.COS-S3-ENDPOINT} ${self.triggers.ACCESS-KEY} ${self.triggers.SECRET-KEY}" 
    #command = "./deleteCOS.sh appdev-cloud-native-bucket https://s3.us.cloud-object-storage.appdomain.cloud 90cd7189490b4cda8198cd0b122081ab 8d5baa706d9703bdfb76ff3fa6b4352e76d2ca64ff4e1911" 
    interpreter = ["/bin/sh", "-c"]    
  }
}

