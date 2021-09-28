output "masked_metrics_id" {
  value = module.masked_metrics.id
}
output "masked_metrics_arn" {
  value = module.masked_metrics.arn
}

output "unmasked_metrics_id" {
  value = module.unmasked_metrics.id
}

output "unmasked_metrics_arn" {
  value = module.unmasked_metrics.arn
}

output "metrics_error_log_id" {
  value = module.metrics_error_log.s3_bucket_id
}

output "metrics_error_log_arn" {
  value = module.metrics_error_log.s3_bucket_arn
}
