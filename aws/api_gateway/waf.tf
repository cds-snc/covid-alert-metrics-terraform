##
#  Mectrics Collection Dev WAF
##

resource "aws_wafv2_web_acl" "metrics_collection" {
  name        = "metrics_collection1"
  description = "WAF for API protection"
  scope       = "REGIONAL"

  default_action {
    allow {}
  }

  rule {
    name     = "AWSManagedRulesAmazonIpReputationList"
    priority = 1

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesAmazonIpReputationList"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWSManagedRulesAmazonIpReputationList"
      sampled_requests_enabled   = true
    }
  }

  rule {
    name     = "metrics_collection_invalid_path"
    priority = 10

    action {
      block {
        custom_response {
          response_code = 204
        }
      }
    }

    statement {
      not_statement {
        statement {
          byte_match_statement {
            positional_constraint = "EXACTLY"
            field_to_match {
              uri_path {}
            }
            search_string = "/save-metrics"
            text_transformation {
              priority = 1
              type     = "COMPRESS_WHITE_SPACE"
            }
            text_transformation {
              priority = 2
              type     = "LOWERCASE"
            }
          }
        }
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "metrics_collection_invalid_path"
      sampled_requests_enabled   = true
    }
  }

  rule {
    name     = "metrics_collection_query_strings"
    priority = 11

    action {
      block {
        custom_response {
          response_code = 204
        }
      }
    }

    statement {
      regex_pattern_set_reference_statement {
        arn = aws_wafv2_regex_pattern_set.anything.arn
        field_to_match {
          query_string {}
        }
        text_transformation {
          priority = 1
          type     = "NONE"
        }
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "metrics_collection_query_strings"
      sampled_requests_enabled   = true
    }
  }

  rule {
    name     = "metrics_collection_rate_limit"
    priority = 12

    action {
      block {}
    }

    statement {
      rate_based_statement {
        limit              = 10000
        aggregate_key_type = "IP"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "metrics_collection_rate_limit"
      sampled_requests_enabled   = true
    }
  }

  rule {
    name = "metrics_collection_max_body_size"
    action {
      block {
        custom_response {
          response_code = 200
          response_header {
            name  = "waf-block"
            value = "metrics_collection_max_body_size"
          }
        }
      }
    }
    priority = 13

    statement {
      size_constraint_statement {
        comparison_operator = "GT"
        field_to_match {
          body {}
        }
        size = var.api_gateway_max_body_size
        text_transformation {
          priority = 1
          type     = "NONE"
        }
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "metrics_collection_max_body_size"
      sampled_requests_enabled   = true
    }
  }

  rule {
    name     = "AWSManagedRulesCommonRuleSet"
    priority = 20

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesCommonRuleSet"
        vendor_name = "AWS"

        excluded_rule {
          name = "SizeRestrictions_BODY"
        }
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWSManagedRulesCommonRuleSet"
      sampled_requests_enabled   = true
    }
  }

  rule {
    name     = "AWSManagedRulesKnownBadInputsRuleSet"
    priority = 30

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesKnownBadInputsRuleSet"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWSManagedRulesKnownBadInputsRuleSet"
      sampled_requests_enabled   = true
    }
  }

  rule {
    name     = "AWSManagedRulesLinuxRuleSet"
    priority = 40

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesLinuxRuleSet"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWSManagedRulesLinuxRuleSet"
      sampled_requests_enabled   = true
    }
  }

  rule {
    name     = "AWSManagedRulesSQLiRuleSet"
    priority = 50

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesSQLiRuleSet"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWSManagedRulesSQLiRuleSet"
      sampled_requests_enabled   = true
    }
  }



  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "metrics-submission"
    sampled_requests_enabled   = false
  }
}


resource "aws_wafv2_web_acl_association" "waf_association" {
  resource_arn = aws_api_gateway_stage.metrics.arn
  web_acl_arn  = aws_wafv2_web_acl.metrics_collection.arn
}

resource "aws_wafv2_regex_pattern_set" "anything" {
  name        = "MatchAll"
  description = "Regex to match all"
  scope       = "REGIONAL"

  regular_expression {
    regex_string = ".+"
  }
}

#
# Write WAF logs to S3
#
resource "aws_wafv2_web_acl_logging_configuration" "covid_metrics_waf_logs" {
  log_destination_configs = [aws_kinesis_firehose_delivery_stream.covid_metrics_waf_logs.arn]
  resource_arn            = aws_wafv2_web_acl.metrics_collection.arn
}

resource "aws_kinesis_firehose_delivery_stream" "covid_metrics_waf_logs" {
  name        = "aws-waf-logs-covid-metrics"
  destination = "extended_s3"

  server_side_encryption {
    enabled = true
  }

  extended_s3_configuration {
    role_arn           = aws_iam_role.write_waf_logs.arn
    prefix             = "waf_acl_logs/AWSLogs/${var.account_id}/covid-metrics/"
    bucket_arn         = "arn:aws:s3:::${var.cbs_satellite_bucket_name}"
    compression_format = "GZIP"
  }

  tags = {
    CostCenter = var.billing_code
    Terraform  = true
  }
}

resource "aws_iam_role" "write_waf_logs" {
  name               = "write-waf-logs"
  assume_role_policy = data.aws_iam_policy_document.firehose_assume_role.json

  tags = {
    CostCentre = var.billing_code
    Terraform  = true
  }
}

resource "aws_iam_policy" "write_waf_logs" {
  name        = "write-waf-logs"
  description = "Allow writing WAF logs to S3"
  policy      = data.aws_iam_policy_document.write_waf_logs.json

  tags = {
    CostCentre = var.billing_code
    Terraform  = true
  }
}

resource "aws_iam_role_policy_attachment" "write_waf_logs" {
  role       = aws_iam_role.write_waf_logs.name
  policy_arn = aws_iam_policy.write_waf_logs.arn
}

data "aws_iam_policy_document" "firehose_assume_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["firehose.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "write_waf_logs" {
  statement {
    sid    = "S3PutObjects"
    effect = "Allow"
    actions = [
      "s3:AbortMultipartUpload",
      "s3:GetBucketLocation",
      "s3:GetObject",
      "s3:ListBucket",
      "s3:ListBucketMultipartUploads",
      "s3:PutObject"
    ]
    resources = [
      "arn:aws:s3:::${var.cbs_satellite_bucket_name}",
      "arn:aws:s3:::${var.cbs_satellite_bucket_name}/waf_acl_logs/*"
    ]
  }
}
