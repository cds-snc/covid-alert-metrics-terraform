###
# ECR Input
###
variable "csv_etl_repository_url" {
  type = string
}

variable "csv_etl_tag" {
  type = string
}

variable "create_csv_ecr_arn" {
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

variable "unmasked_metrics_s3_arn" {
  type = string

}

variable "masked_metrics_s3_arn" {
  type = string
}

