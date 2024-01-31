variable "vpc_cidr_block" {
  type        = string
  description = "vpc cidr block"
}

variable "public_cidr_block" {
  type        = string
  description = "public subnet cidr block"
}

variable "public_cidr_block_2" {
  type        = string
  description = "public subnet cidr block 2"
}

variable "private_cidr_block" {
  type        = string
  description = "private subnet cidr block"
}

variable "avail_zone_1a" {
  type        = string
  description = "Availability Zone 1a"
}

variable "avail_zone_1b" {
  type        = string
  description = "Availability Zone 1b"
}