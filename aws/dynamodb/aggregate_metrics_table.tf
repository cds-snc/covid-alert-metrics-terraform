resource "aws_dynamodb_table" "aggregate_metrics" {

  name         = "aggregate_metrics"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "pk"
  range_key    = "sk"

  server_side_encryption {
    enabled = true
  }

  attribute {
    name = "pk"
    type = "S"
  }

  attribute {
    name = "sk"
    type = "S"
  }

  attribute {
    name = "identifier"
    type = "S"
  }

  point_in_time_recovery {
    enabled = true
  }

  global_secondary_index {
    name            = "IdentifierIndex"
    hash_key        = "identifier"
    projection_type = "ALL"
  }

}