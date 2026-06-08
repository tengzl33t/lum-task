resource "aws_cloudwatch_log_group" "healthcheck_lambda_log_group" {
  name              = "${var.healthcheck_lambda_function_name}-lambda-log-group"
  retention_in_days = 14
  kms_key_id = var.healthcheck_cw_arn
}

resource "aws_cloudwatch_log_group" "healthcheck_apigw_log_group" {
  name              = "${var.healthcheck_lambda_function_name}-apigw-log-group"
  retention_in_days = 14
  kms_key_id = var.healthcheck_cw_arn
}

resource "aws_cloudwatch_log_resource_policy" "apigw" {
  policy_name = "${var.healthcheck_lambda_function_name}-apigw-cw-policy"

  policy_document = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowApiGatewayLogging"
        Effect = "Allow"
        Principal = {
          Service = "apigateway.amazonaws.com"
        }
        Action = [
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:DescribeLogStreams"
        ]
        Resource = "*"
      }
    ]
  })
}