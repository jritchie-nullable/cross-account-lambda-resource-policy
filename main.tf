# Using data here to not hardcode acct numbers or regions
data "aws_caller_identity" "development" { provider = aws.development }
data "aws_region" "development" { provider = aws.development }

data "aws_caller_identity" "testing" { provider = aws.testing }
data "aws_region" "testing" { provider = aws.testing }

data "aws_caller_identity" "production" { provider = aws.production }
data "aws_region" "production" { provider = aws.production }


# Setup the orchistration account lambda
module "orchistration_lambda" {
  source    = "./orchistration-lambda"
  providers = { aws = aws.orchistration }

  development_lambda_arn = "arn:aws:lambda:${data.aws_region.development.name}:${data.aws_caller_identity.development.account_id}:function:get-hello-rp"
  testing_lambda_arn     = "arn:aws:lambda:${data.aws_region.testing.name}:${data.aws_caller_identity.testing.account_id}:function:get-hello-rp"
  production_lambda_arn  = "arn:aws:lambda:${data.aws_region.production.name}:${data.aws_caller_identity.production.account_id}:function:get-hello-rp"
}

# Setup the development lambda
module "development_lambda" {
  source    = "./account-lambda"
  providers = { aws = aws.development }

  orchistration_principal_arn = module.orchistration_lambda.orchistration_lambda_principal_arn
}

# Setup the testing lambda
module "testing_lambda" {
  source    = "./account-lambda"
  providers = { aws = aws.testing }

  orchistration_principal_arn = module.orchistration_lambda.orchistration_lambda_principal_arn
}

# Setup the production lambda
module "production_lambda" {
  source    = "./account-lambda"
  providers = { aws = aws.production }

  orchistration_principal_arn = module.orchistration_lambda.orchistration_lambda_principal_arn
}

