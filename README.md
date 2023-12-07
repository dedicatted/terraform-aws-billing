# Terraform Module: terraform-aws-billing
# This module facilitates the creation of AWS Budgets with flexible notification options, including email, Slack, and Google Chat.

## Overview
The `terarform-aws-billing` module enables you to easily deploy AWS Budgets, helping you monitor and control your AWS spending. The module supports multiple notification channels, allowing you to receive alerts through email, Slack, and Google Chat when your account budget thresholds are reached.

## Usage
```hcl
//Configuration for both email and Google chat webhook
module billing {
  source = "github.com/dedicatted/terraform-aws-billing"
  subscriber_email_addresses = ["test@gmail.com"]
  google_chat_webhook = "/v1/spaces/space/messages?key=key&token=token"
  google_chat_webhook_enabled = true
}
```
```hcl
//Configuration for Google chat webhook
module billing {
  source = "github.com/dedicatted/terraform-aws-billing"
  subscriber_email_addresses = []
  google_chat_webhook = "/v1/spaces/space/messages?key=key&token=token"
  google_chat_webhook_enabled = true
}
```
```hcl
//Configuration for email
module billing {
  source = "github.com/dedicatted/terraform-aws-billing"
  subscriber_email_addresses = ["test@gmail.com"]
}
```

## How to create Slack email

 -   From your desktop, open the channel or DM you’d like to send email to.
 -  Click the channel or member name(s) in the conversation header. 
 -   Click the Integrations tab. 
 -   Select Send emails to this [channel] or [conversation]. 
 -   Click Get Email Address. 
 -   If you’d like to set up an automatic forwarding rule from your email provider or add the email to your address book, click Copy next to the email address.
 -   If you created an email address for a channel, Slackbot will post a message that’s only visible to you with a prompt to let members know an email address has been created. Click Share Email Address to post a message to the channel with any details you’d like. Otherwise, click Dismiss.

## How to create Google chat webhook

 - In a browser, open Chat. Webhooks aren't configurable from the Chat mobile app.
 - Go to the space where you want to add a webhook.
 - Next to the space title, click the expand_more expand more arrow, and then click Apps & integrations.
 - Click addAdd webhooks.
 - In the Name field, enter Quickstart Webhook.
 - (Optional) In the Avatar URL field, enter https://developers.google.com/chat/images/chat-product-icon.png.
 - Click Save.
 - To copy the webhook URL, click more_vert More, and then click content_copyCopy link.

## Lambda usage

AWS Lambda in conjunction with SNS for sending notifications provides a serverless, scalable, and cost-effective solution that simplifies the management and delivery of notifications in a cloud environment.

```nodejs
var https = require('https');
var util = require('util');

exports.handler = function(event, context) {
    console.log(JSON.stringify(event, null, 2));
    console.log('From SNS:', event.Records[0].Sns.Message);

    var message = event.Records[0].Sns.Message;
    
    var postData = {
        "text": message
    };

    var options = {
        method: 'POST',
        hostname: 'chat.googleapis.com',
        port: 443,
        path: process.env.CHAT_API_PATH
    };

    var req = https.request(options, function(res) {
      res.setEncoding('utf8');
      res.on('data', function (chunk) {
        context.done(null);
      });
    });
    
    req.on('error', function(e) {
      console.log('problem with request: ' + e.message);
    });    

    req.write(util.format("%j", postData));
    req.end();
};
```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.47 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 4.47 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_budgets_budget.account_budget](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/budgets_budget) | resource |
| [aws_iam_role.lambda_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_lambda_function.notificator](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) | resource |
| [aws_lambda_permission.permissions](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission) | resource |
| [aws_sns_topic.topic](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic) | resource |
| [aws_sns_topic_policy.topic_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic_policy) | resource |
| [aws_sns_topic_subscription.subscription](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic_subscription) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_sns_topic_name"></a> [aws\_sns\_topic\_name](#input\_aws\_sns\_topic\_name) | What kind of budget value to notify on. Can be ACTUAL or FORECASTED. | `string` | `"budget"` | no |
| <a name="input_budget_name"></a> [budget\_name](#input\_budget\_name) | The name for your budget. | `string` | `"Account budget"` | no |
| <a name="input_budget_type"></a> [budget\_type](#input\_budget\_type) | Whether this budget tracks monetary cost or usage. In current setup only monetary cost is tracked. | `string` | `"COST"` | no |
| <a name="input_comparison_operator"></a> [comparison\_operator](#input\_comparison\_operator) | Comparison operator to use to evaluate the condition. Can be LESS\_THAN, EQUAL\_TO or GREATER\_THAN. | `string` | `"GREATER_THAN"` | no |
| <a name="input_filename"></a> [filename](#input\_filename) | ZIP archive with Lambda code. Must be 'index.zip' unless you change the archive name. | `string` | `"index.zip"` | no |
| <a name="input_function_name"></a> [function\_name](#input\_function\_name) | Lambda function name. Used to send notifications to Google chat. | `string` | `"notificator"` | no |
| <a name="input_google_chat_webhook"></a> [google\_chat\_webhook](#input\_google\_chat\_webhook) | Google chat webhook url where to send notifications. Must start with '/v1/spaces/...' | `string` | `""` | no |
| <a name="input_google_chat_webhook_enabled"></a> [google\_chat\_webhook\_enabled](#input\_google\_chat\_webhook\_enabled) | Whether to turn on Google chat notifications. | `bool` | `false` | no |
| <a name="input_handler"></a> [handler](#input\_handler) | Lambda function handler. Must be 'index.handler' unless you change it in Lambda code. | `string` | `"index.handler"` | no |
| <a name="input_lambda_role_name"></a> [lambda\_role\_name](#input\_lambda\_role\_name) | Lambda IAM role name. | `string` | `"notificator-lambda-role"` | no |
| <a name="input_limit_amount"></a> [limit\_amount](#input\_limit\_amount) | The amount of cost for a budget. | `number` | `"1.30"` | no |
| <a name="input_limit_unit"></a> [limit\_unit](#input\_limit\_unit) | The unit of measurement used for the budget forecast, actual spend, or budget threshold, such as dollars or GB. In current setup only dollars measurement is implemented. | `string` | `"USD"` | no |
| <a name="input_notification_type"></a> [notification\_type](#input\_notification\_type) | What kind of budget value to notify on. Can be ACTUAL or FORECASTED. | `string` | `"ACTUAL"` | no |
| <a name="input_region"></a> [region](#input\_region) | AWS region to deploy. | `string` | `"us-east-1"` | no |
| <a name="input_runtime"></a> [runtime](#input\_runtime) | Lambda function runtime. Must be nodejs as Lambda code is written on nodejs. | `string` | `"nodejs20.x"` | no |
| <a name="input_subscriber_email_addresses"></a> [subscriber\_email\_addresses](#input\_subscriber\_email\_addresses) | E-Mail addresses to notify. | `set(string)` | <pre>[<br>  "example12345@gmail.com"<br>]</pre> | no |
| <a name="input_threshold_type"></a> [threshold\_type](#input\_threshold\_type) | What kind of threshold is defined. Can be PERCENTAGE OR ABSOLUTE\_VALUE. | `string` | `"ABSOLUTE_VALUE"` | no |
| <a name="input_time_period_end"></a> [time\_period\_end](#input\_time\_period\_end) | The end of the time period covered by the budget. There are no restrictions on the end date. Format: 2017-01-01\_12:00 | `string` | `""` | no |
| <a name="input_time_period_start"></a> [time\_period\_start](#input\_time\_period\_start) | The start of the time period covered by the budget. If you don't specify a start date, AWS defaults to the start of your chosen time period. The start date must come before the end date. Format: 2017-01-01\_12:00 | `string` | `""` | no |
| <a name="input_time_unit"></a> [time\_unit](#input\_time\_unit) | The length of time until a budget resets the actual and forecasted spend. Valid values: MONTHLY, QUARTERLY, ANNUALLY, and DAILY. | `string` | `"MONTHLY"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_limit_amount"></a> [limit\_amount](#output\_limit\_amount) | n/a |
| <a name="output_subscriber_email_addresses"></a> [subscriber\_email\_addresses](#output\_subscriber\_email\_addresses) | n/a |
| <a name="output_subscriber_sns_topic_arns"></a> [subscriber\_sns\_topic\_arns](#output\_subscriber\_sns\_topic\_arns) | n/a |
