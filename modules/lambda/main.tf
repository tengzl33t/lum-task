data "archive_file" "healthcheck_lambda_code_file" {
  type        = "zip"
  source_dir = "${path.module}/code/${var.environment}"
  output_path = "${path.root}/.terraform/build/${var.environment}-healthcheck-lambda-code.zip"
}

resource "aws_lambda_function" "healthcheck_lambda" {
  function_name                  = "${var.environment}-healthcheck-lambda"
  role                           = var.healthcheck_lambda_iam_role_arn

  runtime                        = "python3.14"
  handler = "main.lambda_handler"
  filename = data.archive_file.healthcheck_lambda_code_file.output_path
  source_code_hash = data.archive_file.healthcheck_lambda_code_file.output_base64sha256

  environment {
    variables = {
      ENVIRONMENT = var.environment
      LOG_LEVEL   = var.log_level
    }
  }
}