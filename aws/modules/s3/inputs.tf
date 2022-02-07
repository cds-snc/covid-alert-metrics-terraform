variable "name" {
  type        = string
  description = "(required) Name to use for the bucket"
}

variable "cbs_satellite_bucket_name" {
  description = "(Required) Name of the Cloud Based Sensor S3 satellite bucket"
  type        = string
}
