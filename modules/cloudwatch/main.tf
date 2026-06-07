resource "aws_cloudwatch_log_group" "healthcheck_lambda_log_group" {
  name              = "/aws/lambda/${var.healthcheck_lambda_function_name}"
  retention_in_days = 14
}

resource "aws_cloudwatch_log_group" "healthcheck_apigw_log_group" {
  name              = "/aws/apigw/${var.healthcheck_lambda_function_name}"
  retention_in_days = 14
}