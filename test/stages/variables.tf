
# Resource Group Variables
variable "resource_group_name" {
  type        = string
  description = "Existing resource group where the IKS cluster will be provisioned."
}

variable "ibmcloud_api_key" {
  type        = string
  description = "The api key for IBM Cloud access"
}

variable "region" {
  type        = string
  description = "Region for VLANs defined in private_vlan_number and public_vlan_number."
}

variable "name_prefix" {
  type        = string
  description = "Prefix name that should be used for the cluster and services. If not provided then resource_group_name will be used"
  default     = ""
}

variable "hpcs_name" {
  type        = string
}

variable "kms_key_name" {
  type        = string
}

variable "hpcs_region" {
  type        = string
}

variable "hpcs_resource_group_name" {
  type        = string
}

variable "cross_region_location" {
  type    = string
  default = ""
}

variable "COS-S3-ENDPOINT" {
  type        = string
  description = "S3-ENDPOINT of COS - https://s3.us.cloud-object-storage.appdomain.cloud for us "
  #default     = "https://s3.us.cloud-object-storage.appdomain.cloud"
}

variable "ACCESS-KEY" {
  type        = string
  description = "ACCESS-KEY of COS"
  #default     = "90cd7189490b4cda8198cd0b122081ab"
}

variable "SECRET-KEY" {
  type        = string
  description = "SECRET-KEY of COS"
  #default     = "8d5baa706d9703bdfb76ff3fa6b4352e76d2ca64ff4e1911"
}
