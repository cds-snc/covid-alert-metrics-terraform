###
# Lambda Configuration
### 
variable "unmasked_metrics_environment_variables" {
  type = map(string)
}

variable "masked_metrics_environment_variables" {
  type = map(string)
}

variable "memory_size" {
  type = number
}

###
# ECR Input
###
variable "csv_etl_repository_url" {
  type        = string
  description = "ECR Repository url for etl images"
}

variable "csv_etl_tag" {
  type = string
}

variable "create_csv_repository_arn" {
  type = string
}

###
# Network inputs
###

variable "csv_etl_sg_id" {
  type = string
}

variable "efs_sg_id" {
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
