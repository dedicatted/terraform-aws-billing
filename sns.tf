resource "aws_sns_topic" "default" {
  count = var.google_chat_webhook_enabled ? 1 : 0
  name  = var.aws_sns_topic_name
}

resource "aws_sns_topic_subscription" "default" {
  count     = var.google_chat_webhook_enabled ? 1 : 0
  topic_arn = aws_sns_topic.default[count.index].arn
  protocol  = "lambda"
  endpoint  = aws_lambda_function.default[count.index].arn
}

resource "aws_sns_topic_policy" "default" {
  count = var.google_chat_webhook_enabled ? 1 : 0
  arn   = aws_sns_topic.default[count.index].arn

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Id": "BudgetsPolicy",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "budgets.amazonaws.com"
      },
      "Action": "SNS:Publish",
      "Resource": "${aws_sns_topic.default[count.index].arn}",
      "Condition": {
        "ArnLike": {
          "aws:SourceArn": "arn:aws:budgets:*:${data.aws_caller_identity.current.account_id}:budget/*"
        }
      }
    }
  ]
}
EOF
}
