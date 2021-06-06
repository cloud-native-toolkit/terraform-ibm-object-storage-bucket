variable "resource_group_name" {
  type        = string
  description = "The name of the IBM Cloud resource group where the VPC instance will be created."
}

variable "provision" {
    description = "Flag indicating that the instance should be provisioned. If false then an existing instance will be looked up"
    type        = bool
    default = true
}

variable "cos_instance_id" {
    description = "id of the COS instance"
    type        = string
}

variable "name_prefix" {
  type        = string
  description = "The name of the cos resource"
  default     = ""
}

variable "name" {
  description = "Name of the bucket"
  type        = string
  default     = ""
}

variable "label" {
  description = "Label used to build the bucket name of not provided."
  type        = string
  default     = "bucket"
}

variable "region" {
  description = "Bucket region"
  type        = string
}

variable "cross_region_location" {
  description = "The cross-region location of the bucket. This value is optional. Valid values are (us, eu, and ap). This value takes precedence over others if provided."
  type        = string
  default     = ""

  validation {
    condition     = contains(["", "us", "eu", "ap"], var.cross_region_location)
    error_message = "The cross_region location must be either 'us', 'eu', or 'ap'."
  }
}

variable "storage_class" {
    description = "Storage class of the bucket. Supported values are standard, vault, cold, flex, smart."
    type        = string
    default     = "standard"
}

variable "ibmcloud_api_key" {
  type        = string
  description = "The IBM Cloud api token"
}

variable "kms_key_crn" {
  type        = string
  description = "The crn of the root key in the KMS"
  default     = null
}

variable "activity_tracker_crn" {
  type        = string
  description = "The crn of the Activity Tracking instance"
  default     = null
}

variable "metrics_monitoring_crn" {
  type        = string
  description = "The crn of the Metrics Monitoring instance"
  default     = null
}

variable "allowed_ip" {
  type        = list(string)
  description = "A list of IPv4 or IPv6 addresses in CIDR notation that you want to allow access to your IBM Cloud Object Storage bucket."
  default     = null
}

variable "vpc_ip_addresses" {
  type        = list(string)
  description = "The list of ip addresses in the VPC that should be allowed to access the bucket."
  default     = null
}

variable "cos_key_id" {
  type        = string
  description = "The id of the key provisioned for the COS instance"
  default     = ""
}
