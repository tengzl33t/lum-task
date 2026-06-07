resource "aws_kms_key" "requests_db" {
  enable_key_rotation = true
}
