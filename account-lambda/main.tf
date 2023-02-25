data "aws_caller_identity" "current" {}

# Package the get-hello lambda code into a zip
data "archive_file" "get_hello" {
  type        = "zip"
  source_file = "${path.module}/index.mjs"
  output_path = "${path.module}/get-hello.zip"
}

# A policy to enable the lambda to write to cloudwatch logs
data "aws_iam_policy_document" "lambda_policy_document" {
  statement {
    actions = [
      "logs:CreateLogGroup"
    ]
    resources = [
      "arn:aws:logs::${data.aws_caller_identity.current.account_id}:*"
    ]
  }

  statement {
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = [
      "arn:aws:logs::${data.aws_caller_identity.current.account_id}:log-group:/aws/lambda/get-hello-rp:*"
    ]
  }
}

# A policy to allow lambda to assume a role
data "aws_iam_policy_document" "lambda_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

# The iam role for the lambda
resource "aws_iam_role" "lambda_role" {
  name               = "xacct-lambda-role-rp"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role_policy.json
}

# The iam policy for the lambda
resource "aws_iam_policy" "lambda_policy" {
  name   = "xacct-lambda-policy-rp"
  policy = data.aws_iam_policy_document.lambda_policy_document.json
}

resource "aws_iam_policy_attachment" "lambda_role_policy_attachment" {
  name       = "xacct-lambda-policy-attachment-rp"
  roles      = [aws_iam_role.lambda_role.name]
  policy_arn = aws_iam_policy.lambda_policy.arn
}

# The lambda
resource "aws_lambda_function" "get_hello" {
  architectures = ["arm64"]
  function_name = "get-hello-rp"
  filename      = "${path.module}/get-hello.zip"
  role          = aws_iam_role.lambda_role.arn
  runtime       = "nodejs18.x"
  handler       = "index.handler"
}

# The resource policy
resource "aws_lambda_permission" "get_hello_permission" {
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.get_hello.function_name
  principal     = var.orchistration_principal_arn
  statement_id  = "x-acct-access"
}

