data "aws_iam_policy_document" "lambda_iam_role_assume_role" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "healthcheck_lambda_iam_role" {
  name = "${var.environment}-healthcheck-lambda-iam-role"
  assume_role_policy = data.aws_iam_policy_document.lambda_iam_role_assume_role.json
}

resource "aws_iam_role_policy_attachment" "healthcheck_lambda_iam_policy" {
  role       = aws_iam_role.healthcheck_lambda_iam_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}
