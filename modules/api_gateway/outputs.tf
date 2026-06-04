output "apigateway_url" {
  value = aws_apigatewayv2_api.healthcheck_apigw.api_endpoint
}

output "healthcheck_apigw_exec_arn" {
  value = aws_apigatewayv2_api.healthcheck_apigw.execution_arn
}