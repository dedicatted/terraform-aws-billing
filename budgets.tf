resource "aws_budgets_budget" "account_budget" {
  name              = var.budget_name
  budget_type       = var.budget_type
  limit_amount      = var.limit_amount
  limit_unit        = var.limit_unit
  time_period_end   = var.time_period_end != "" ? var.time_period_end : null
  time_period_start = var.time_period_start != "" ? var.time_period_start : null
  time_unit         = var.time_unit

  depends_on = [aws_lambda_function.notificator, aws_sns_topic.topic, aws_sns_topic_subscription.subscription]

  notification {
    comparison_operator        = var.comparison_operator
    threshold                  = var.limit_amount
    threshold_type             = var.threshold_type
    notification_type          = var.notification_type
    subscriber_email_addresses = length(var.subscriber_email_addresses) != 0 ? [for value in var.subscriber_email_addresses : value] : null
    subscriber_sns_topic_arns  = var.google_chat_webhook_enabled ? [aws_sns_topic.topic[0].arn] : null
  }
}
