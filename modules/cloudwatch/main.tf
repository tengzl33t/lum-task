resource "aws_cloudwatch_log_group" "healthcheck_lambda_log_group" {
  name              = "/aws/lambda/${var.healthcheck_lambda_function_name}"
  retention_in_days = 14
  kms_key_id = var.healthcheck_cw_arn
}

resource "aws_cloudwatch_log_group" "healthcheck_apigw_log_group" {
  name              = "/aws/apigw/${var.healthcheck_lambda_function_name}"
  retention_in_days = 14
  kms_key_id = var.healthcheck_cw_arn
}