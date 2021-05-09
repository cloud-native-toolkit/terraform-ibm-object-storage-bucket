output "bucket_name" {
  description = "The name of the COS bucket instance"
  value = data.ibm_cos_bucket.bucket_instance.bucket_name
}

output "id" {
  description = "The ID of the COS bucket instance"
  value = data.ibm_cos_bucket.bucket_instance.id
}

output "crn" {
  description = "The CRN of the COS bucket instance"
  value = data.ibm_cos_bucket.bucket_instance.crn
}
