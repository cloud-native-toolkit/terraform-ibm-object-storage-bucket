variable "resource_group_name" {
  type        = string
  description = "Resource group where the cluster has been provisioned."
}

variable "instance-region" {
  type        = string
  description = "The region where the object storage instance has been provisioned"
}

variable "instance-name" {
  type        = string
  description = "The name of the object storage instance"
}

variable "region" {
  type        = string
  description = "The region where the bucket where be created"
}

variable "name" {
  type        = string
  description = "The name of the bucket that will be created"
}

variable "storage-class" {
  type        = string
  description = "The storage class for the bucket"
  default     = "flex"
}
