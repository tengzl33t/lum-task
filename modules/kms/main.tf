resource "aws_kms_key" "requests_db" {
  enable_key_rotation = true
}

resource "aws_kms_key" "healthcheck_cw" {
  enable_key_rotation = true
}

resource "aws_kms_alias" "healthcheck_cw" {
  name          = "alias/${var.environment}-healthcheck-cw"
  target_key_id = aws_kms_key.healthcheck_cw.key_id
}