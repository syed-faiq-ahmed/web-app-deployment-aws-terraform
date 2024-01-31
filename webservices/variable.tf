variable "ports" {
  type = list(number)
}

variable "image_id" {
  type        = string
  description = "Image ID"
}

variable "instance_type" {
  type        = string
  description = "Instance Type"
}

variable "min_size" {
  type        = number
  description = "Minimum Size"
}

variable "max_size" {
  type        = number
  description = "Maximum Size"
}

variable "desired_capacity" {
  type        = number
  description = "Desired Capacity"
}

variable "health_check_grace_period" {
  type        = number
  description = "Health Check Grace Period"
}

variable "domain_name" {
  type        = string
  description = "Domain Name"
}

variable "record_name" {
  type        = string
  description = "Record Name"
}

variable "key_name" {
  default = "test"
}