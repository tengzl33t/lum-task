output "healthcheck_url" {
  value = "${module.api_gateway.apigateway_url}/health"
}