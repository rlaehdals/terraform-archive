module "sns" {
  source  = "terraform-aws-modules/sns/aws"
  version = "v5.3.0"
  name = var.sns_name

  topic_policy_statements = {
    sqs = {
      sid = "SQSSubscribe"
      actions = [
        "sns:Subscribe",
        "sns:Receive",
      ]

      principals = [{
        type        = "AWS"
        identifiers = ["*"]
      }]

      conditions = [{
        test     = "StringLike"
        variable = "sns:Endpoint"
        values   = [module.sqs.queue_arn]
      }]
    }
  }

  subscriptions = {
    sqs = {
      protocol = "sqs"
      endpoint = module.sqs.queue_arn
    }
  }

  tags = var.tags
}

module "sqs" {
  source = "terraform-aws-modules/sqs/aws"
  version = "v4.0.2"
  
  name = var.sqs_name

  create_queue_policy = true

  queue_policy_statements = {
    sns = {
      sid     = "SNSPublish"
      actions = ["sqs:SendMessage"]

      principals = [
        {
          type        = "Service"
          identifiers = ["sns.amazonaws.com"]
        }
      ]

      conditions = [{
        test     = "ArnEquals"
        variable = "aws:SourceArn"
        values   = [module.sns.topic_arn]
      }]
    }
  }

  tags = var.tags
}

resource "aws_scheduler_schedule" "scheduler" {
  name       = var.event_bridge_name
  group_name = "default"

  flexible_time_window {
    mode = "OFF"
  }

  schedule_expression = var.event_bridge_scheduler_cron

  target {
    arn      = module.sns.topic_arn
    role_arn = aws_iam_role.sns_role.arn
  }
}

resource "aws_iam_role" "sns_role" {
  name               = "sns_role"

  assume_role_policy = var.event_scheduler_role
}

resource "aws_iam_role_policy_attachment" "scheduler_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonSNSFullAccess"
  role       = aws_iam_role.sns_role.name
}