data "archive_file" "healthcheck_lambda_code_file" {
  type        = "zip"
  source_dir = "${path.module}/code/${var.environment}"
  output_path = "${path.root}/.terraform/build/${var.environment}-healthcheck-lambda-code.zip"
}

resource "aws_lambda_function" "healthcheck_lambda" {
  function_name                  = "${var.environment}-healthcheck-lambda"
  role                           = var.healthcheck_lambda_iam_role_arn

  runtime                        = "python3.12"
  handler = "main.lambda_handler"
  filename = data.archive_file.healthcheck_lambda_code_file.output_path
  source_code_hash = data.archive_file.healthcheck_lambda_code_file.output_base64sha256

  tracing_config {
    mode = "Active"
  }

  environment {
    variables = {
      ENVIRONMENT = var.environment
      LOG_LEVEL   = var.log_level
    }
  }

  vpc_config {
    subnet_ids         = [var.healthcheck_subnet_id]
    security_group_ids = [var.healthcheck_sg_id]
  }
}

resource "aws_lambda_permission" "apigw" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.healthcheck_lambda.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${var.healthcheck_apigw_exec_arn}/*/*"
}