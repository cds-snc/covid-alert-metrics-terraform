###
# Policies
### 

variable "vpc_networking_policy" {
  type = string
}

variable "write_csv_buckets_arn" {
  type = string
}
variable "pull_csv_image_arn" {
  type = string
}

###
# Container Inputs
###
variable "csv_etl_repository_url" {
  type = string
}

variable "csv_etl_tag" {
  type = string
}

###
# Network inputs
###

variable "csv_etl_sg_id" {
  type = string
}

variable "metrics_private_subnet_id" {
  type = string
}

###
# Buckets
###

variable "masked_metrics_bucket" { 
  type = string
}

variable "unmasked_metrics_bucket" { 
  type = string
}