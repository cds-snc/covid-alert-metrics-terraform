variable "cpu_units" {
  type    = number
  default = 512
}

variable "memory" {
  type    = number
  default = 1024
}

variable "min_capacity" {
  type    = number
  default = 1
}

variable "sg_id" {
  type = string
}

variable "subnet_id" {
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

variable "unmasked_metrics_s3_arn" {
  type = string

}

variable "masked_metrics_s3_arn" {
  type = string
}

###
# ECR Input
###
variable "csv_etl_repository_url" {
  type        = string
  description = "ECR Repository url for etl images"
}


variable "create_csv_repository_arn" {
  type = string
}

variable "billing_tag_key" {
  type = string
}

variable "billing_tag_value" {
  type = string
}


###
# ECS Task tags
###
variable "masked_image_tag" {
  type = string
}

variable "unmasked_image_tag" {

}