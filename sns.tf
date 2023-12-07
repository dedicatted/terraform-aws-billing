resource "aws_sns_topic" "topic" {
  count = var.google_chat_webhook_enabled ? 1 : 0
  name  = var.aws_sns_topic_name
}

resource "aws_sns_topic_subscription" "subscription" {
  count     = var.google_chat_webhook_enabled ? 1 : 0
  topic_arn = aws_sns_topic.topic[count.index].arn
  protocol  = "lambda"
  endpoint  = aws_lambda_function.aws_lambda_function[count.index].arn
}

resource "aws_sns_topic_policy" "topic_policy" {
  count = var.google_chat_webhook_enabled ? 1 : 0
  arn   = aws_sns_topic.topic[count.index].arn

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
      "Resource": "${aws_sns_topic.topic[count.index].arn}",
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
