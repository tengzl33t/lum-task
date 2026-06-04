output "healthcheck_lambda_invoke_arn" {
  value = aws_lambda_function.healthcheck_lambda.invoke_arn
}

output "healthcheck_lambda_function_name" {
  value = aws_lambda_function.healthcheck_lambda.function_name
}