resource "aws_lambda_function" "default" {
  count         = var.google_chat_webhook_enabled ? 1 : 0
  function_name = var.function_name
  runtime       = var.runtime
  handler       = var.handler
  filename      = "${path.module}/${var.filename}"
  role          = aws_iam_role.default[count.index].arn

  environment {
    variables = {
      CHAT_API_PATH = var.google_chat_webhook != "" ? var.google_chat_webhook : "PROVIDE_VALID_WEBHOOK_URL"
    }
  }
}

resource "aws_iam_role" "default" {
  count = var.google_chat_webhook_enabled ? 1 : 0
  name  = var.lambda_role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com",
        },
      },
    ],
  })
}

resource "aws_lambda_permission" "default" {
  count         = var.google_chat_webhook_enabled ? 1 : 0
  statement_id  = "AllowExecutionFromSNS"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.default[count.index].function_name
  principal     = "sns.amazonaws.com"
  source_arn    = aws_sns_topic.default[count.index].arn
}
