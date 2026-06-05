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
  source          = "./modules/iam"
  environment     = var.environment
  requests_db_arn = module.dynamodb.requests_db_arn
}

module "lambda" {
  source                          = "./modules/lambda"
  healthcheck_lambda_iam_role_arn = module.iam.healthcheck_lambda_iam_role_arn
  environment                     = var.environment
  log_level                       = var.log_level
  healthcheck_apigw_exec_arn      = module.api_gateway.healthcheck_apigw_exec_arn
}

module "cloudwatch" {
  source                           = "./modules/cloudwatch"
  healthcheck_lambda_function_name = module.lambda.healthcheck_lambda_function_name
}

terraform {
  backend "s3" {
    bucket       = "4av1s9fudz9dtvzgt765-tofu-state"
    encrypt      = true
    use_lockfile = true
  }
}

