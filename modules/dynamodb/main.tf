resource "aws_dynamodb_table" "requests_db" {
  hash_key = "request_id"
  name     = "${var.environment}-requests-db"
  billing_mode = "PAY_PER_REQUEST"
  attribute {
    name = "request_id"
    type = "S"
  }
}
