resource "aws_dynamodb_table" "requests_db" {
  hash_key = "request_id"
  name     = "${var.environment}-requests-db"
  billing_mode = "PAY_PER_REQUEST"

  attribute {
    name = "request_id"
    type = "S"
  }

  point_in_time_recovery {
    enabled = true
    recovery_period_in_days = 14
  }
}
