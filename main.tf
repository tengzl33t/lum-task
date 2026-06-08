data "aws_caller_identity" "identity" {}
data "aws_region" "region" {}
data "aws_availability_zones" "azs" {
  state = "available"
}

locals {
  account_id = data.aws_caller_identity.identity.account_id
  region     = data.aws_region.region.region
  az_names   = data.aws_availability_zones.azs.names
}

module "api_gateway" {
  source                          = "./modules/api_gateway"
  healthcheck_lambda_invoke_arn   = module.lambda.healthcheck_lambda_invoke_arn
  environment                     = var.environment
  healthcheck_apigw_log_group_arn = module.cloudwatch.healthcheck_apigw_log_group_arn
}

module "dynamodb" {
  source                  = "./modules/dynamodb"
  environment             = var.environment
  requests_db_kms_key_arn = module.kms.requests_db_kms_key_arn
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
  healthcheck_subnet_id           = module.vpc.healthcheck_subnet_id
  healthcheck_sg_id               = module.vpc.healthcheck_sg_id
}

module "cloudwatch" {
  source                           = "./modules/cloudwatch"
  healthcheck_lambda_function_name = module.lambda.healthcheck_lambda_function_name
  healthcheck_cw_arn               = module.kms.healthcheck_cw_arn
}

module "kms" {
  source                          = "./modules/kms"
  environment                     = var.environment
  account_id                      = local.account_id
  region                          = local.region
  healthcheck_lambda_iam_role_arn = module.iam.healthcheck_lambda_iam_role_arn
}

module "vpc" {
  source      = "./modules/vpc"
  az_names    = local.az_names
  environment = var.environment
  region      = local.region
}

terraform {
  backend "s3" {
    bucket       = "4av1s9fudz9dtvzgt765-tofu-state"
    encrypt      = true
    use_lockfile = true
  }
}

