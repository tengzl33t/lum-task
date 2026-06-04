module "api_gateway" {
  source                        = "./modules/api_gateway"
  healthcheck_lambda_invoke_arn = module.lambda.healthcheck_lambda_invoke_arn
  environment                   = var.environment
}

module "dynamodb" {
  source      = "./modules/dynamodb"
  environment = var.environment
}

module "iam" {
  source      = "./modules/iam"
  environment = var.environment
  requests_db_arn = module.dynamodb.requests_db_arn
}

module "lambda" {
  source                          = "./modules/lambda"
  healthcheck_lambda_iam_role_arn = module.iam.healthcheck_lambda_iam_role_arn
  environment                     = var.environment
  log_level                       = var.log_level
  healthcheck_apigw_exec_arn = module.api_gateway.healthcheck_apigw_exec_arn
}
