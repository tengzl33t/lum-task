resource "aws_apigatewayv2_api" "healthcheck_apigw" {
  name          = "${var.environment}-healthcheck-apigw"
  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_stage" "healthcheck_apigw" {
  api_id      = aws_apigatewayv2_api.healthcheck_apigw.id
  name        = "$default"
  auto_deploy = true

  default_route_settings {
    throttling_rate_limit  = 5
    throttling_burst_limit = 10
  }
}

resource "aws_apigatewayv2_integration" "healthcheck_apigw" {
  api_id = aws_apigatewayv2_api.healthcheck_apigw.id

  integration_uri    = var.healthcheck_lambda_invoke_arn
  integration_type   = "AWS_PROXY"
  integration_method = "POST"
}

resource "aws_apigatewayv2_route" "healthcheck_apigw_post" {
  api_id = aws_apigatewayv2_api.healthcheck_apigw.id

  route_key = "POST /health"
  target    = "integrations/${aws_apigatewayv2_integration.healthcheck_apigw.id}"
}

resource "aws_apigatewayv2_route" "healthcheck_apigw_get" {
  api_id = aws_apigatewayv2_api.healthcheck_apigw.id

  route_key = "GET /health"
  target    = "integrations/${aws_apigatewayv2_integration.healthcheck_apigw.id}"
}