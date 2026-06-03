output "healthcheck_lambda_invoke_arn" {
  value = aws_lambda_function.healthcheck_lambda.invoke_arn
}