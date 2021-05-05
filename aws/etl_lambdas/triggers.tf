
rsource "aws_cloudwatch_event_rule" "twice-a-day" {
  name                = "twice-a-day"
  description         = "Fires twice a day"
  schedule_expression = "cron(0 6,18 * * ? *)"
}

resource "aws_cloudwatch_event_target" "tigger-unmasked_metrics" {
  rule      = aws_cloudwatch_event_rule.twice-a-day.name
  target_id = "unmasked_metrics"
  arn       = aws_lambda_function.unmasked_metrics.arn
}

resource "aws_cloudwatch_event_target" "tigger-masked_metrics" {
  rule      = aws_cloudwatch_event_rule.twice-a-day.name
  target_id = "masked_metrics"
  arn       = aws_lambda_function.masked_metrics.arn
}

resource "aws_lambda_permission" "allow-cloudwatch-to-call-unmasked_metrics" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.unmasked_metrics.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.twice-a-day.arn
}

resource "aws_lambda_permission" "allow-cloudwatch-to-call-masked_metrics" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.masked_metrics.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.twice-a-day.arn
}