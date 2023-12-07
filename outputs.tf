output "limit_amount" {
  value = aws_budgets_budget.account_budget.limit_amount
}

output "subscriber_email_addresses" {
  value = [for notification in aws_budgets_budget.account_budget.notification : notification.subscriber_email_addresses]
}

output "subscriber_sns_topic_arns" {
  value = [for notification in aws_budgets_budget.account_budget.notification : notification.subscriber_sns_topic_arns]
}