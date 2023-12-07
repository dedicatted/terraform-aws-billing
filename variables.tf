variable "region" {
  type        = string
  default     = "us-east-1"
  description = "AWS region to deploy."
}

variable "budget_name" {
  type        = string
  default     = "Account budget"
  description = "The name for your budget."
}

variable "limit_amount" {
  type        = number
  default     = "1.30"
  description = "The amount of cost for a budget."
}

variable "time_period_end" {
  type        = string
  default     = ""
  description = "The end of the time period covered by the budget. There are no restrictions on the end date. Format: 2017-01-01_12:00"
}

variable "time_period_start" {
  type        = string
  default     = ""
  description = "The start of the time period covered by the budget. If you don't specify a start date, AWS defaults to the start of your chosen time period. The start date must come before the end date. Format: 2017-01-01_12:00"
}

variable "time_unit" {
  type        = string
  default     = "MONTHLY"
  description = "The length of time until a budget resets the actual and forecasted spend. Valid values: MONTHLY, QUARTERLY, ANNUALLY, and DAILY."
}

variable "subscriber_email_addresses" {
  type        = set(string)
  default     = ["example12345@gmail.com"]
  description = "E-Mail addresses to notify."
}

variable "budget_type" {
  type        = string
  default     = "COST"
  description = "Whether this budget tracks monetary cost or usage. In current setup only monetary cost is tracked."
}

variable "limit_unit" {
  type        = string
  default     = "USD"
  description = "The unit of measurement used for the budget forecast, actual spend, or budget threshold, such as dollars or GB. In current setup only dollars measurement is implemented."
}

variable "comparison_operator" {
  type        = string
  default     = "GREATER_THAN"
  description = "Comparison operator to use to evaluate the condition. Can be LESS_THAN, EQUAL_TO or GREATER_THAN."
}

variable "threshold_type" {
  type        = string
  default     = "ABSOLUTE_VALUE"
  description = "What kind of threshold is defined. Can be PERCENTAGE OR ABSOLUTE_VALUE."
}

variable "notification_type" {
  type        = string
  default     = "ACTUAL"
  description = "What kind of budget value to notify on. Can be ACTUAL or FORECASTED."
}

variable "aws_sns_topic_name" {
  type        = string
  default     = "default"
  description = "What kind of budget value to notify on. Can be ACTUAL or FORECASTED."
}

variable "function_name" {
  type        = string
  default     = "default"
  description = "Lambda function name. Used to send notifications to Google chat."
}

variable "runtime" {
  type        = string
  default     = "nodejs20.x"
  description = "Lambda function runtime. Must be nodejs as Lambda code is written on nodejs."
}

variable "handler" {
  type        = string
  default     = "index.handler"
  description = "Lambda function handler. Must be 'index.handler' unless you change it in Lambda code."
}

variable "filename" {
  type        = string
  default     = "index.zip"
  description = "ZIP archive with Lambda code. Must be 'index.zip' unless you change the archive name."
}

variable "lambda_role_name" {
  type        = string
  default     = "default"
  description = "Lambda IAM role name."
}

variable "google_chat_webhook" {
  type        = string
  default     = ""
  description = "Google chat webhook url where to send notifications. Must start with '/v1/spaces/...'"
}

variable "google_chat_webhook_enabled" {
  type        = bool
  default     = true
  description = "Whether to turn on Google chat notifications."
}


