resource "aws_cloudtrail" "cloudtrail" {
  name                          = var.cloud_trail_trace_name
  s3_bucket_name                = aws_s3_bucket.monitoring_s3.id
  s3_key_prefix                 = "monitoring"
  include_global_service_events = true
  cloud_watch_logs_group_arn = "${aws_cloudwatch_log_group.cloud_watch_logs_group.arn}:*"
  cloud_watch_logs_role_arn = aws_iam_role.cloud_watch_role.arn
}

resource "aws_cloudwatch_log_group" "cloud_watch_logs_group"{
    name = var.log_group_name
}

resource "aws_s3_bucket" "monitoring_s3" {
  bucket        = var.s3_bucket_name
  force_destroy = true
}

data "aws_iam_policy_document" "cloud_watch_policy_data" {
  statement { 
    sid       = "AWSCloudTrailCreateLogStream2014110"
    effect    = "Allow"
    actions   = ["logs:CreateLogStream"]
    resources = ["${aws_cloudwatch_log_group.cloud_watch_logs_group.arn}:log-stream:${var.account_id}_CloudTrail_us-east-1*"]
  }

  statement {
    sid       = "AWSCloudTrailPutLogEvents20141101"
    effect    = "Allow"
    actions   = ["logs:PutLogEvents"]
    resources = ["${aws_cloudwatch_log_group.cloud_watch_logs_group.arn}:log-stream:${var.account_id}_CloudTrail_us-east-1*"]
  }
}

resource "aws_iam_policy" "cloud_watch_policy" {
  name        = var.cloud_watch_policy_name
  policy      = data.aws_iam_policy_document.cloud_watch_policy_data.json
}

resource "aws_iam_role" "cloud_watch_role" {
  name               = var.cloud_watch_role_name
  assume_role_policy = jsonencode({
      Version   : "2012-10-17",
      Statement : [
        {
          Sid       : "",
          Effect    : "Allow",
          Principal : { Service: ["cloudtrail.amazonaws.com"] },
          Action    : ["sts:AssumeRole"],
        },
      ],
  })
}

resource aws_iam_role_policy_attachment cloudwatch_attachment {
  role       = aws_iam_role.cloud_watch_role.name
  policy_arn = aws_iam_policy.cloud_watch_policy.arn
}


data "aws_iam_policy_document" "s3_policy_data" {
  statement {
    sid    = "AWSCloudTrailAclCheck"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }

    actions   = ["s3:GetBucketAcl"]
    resources = [aws_s3_bucket.monitoring_s3.arn,
    "${aws_s3_bucket.monitoring_s3.arn}/*"]
  }

  statement {
    sid    = "AWSCloudTrailWrite"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }

    actions   = ["s3:PutObject"]
    resources = [aws_s3_bucket.monitoring_s3.arn,
    "${aws_s3_bucket.monitoring_s3.arn}/*"]
  }
}
resource "aws_s3_bucket_policy" "s3_policy" {
  bucket = aws_s3_bucket.monitoring_s3.id
  policy = data.aws_iam_policy_document.s3_policy_data.json
}

resource "aws_sns_topic" "sns_topic" {
  name = var.sns_topic_name
}

resource "aws_sns_topic_subscription" "sns_email_subscription" {
  topic_arn = aws_sns_topic.sns_topic.arn
  protocol  = var.protocol
  endpoint  = var.email
}

resource "aws_cloudwatch_event_rule" "eventbridge_rule" {
  name        = var.event_bridge_rule_name
  
  event_pattern = <<PATTERN
{
  "detail": {
    "eventSource": ["iam.amazonaws.com"],
    "eventName": ["CreateAccessKey"]
  }
}
PATTERN

  role_arn = aws_iam_role.eventbridge_sns_role.arn
}

resource "aws_cloudwatch_event_target" "eventbridge_target" {
  rule      = aws_cloudwatch_event_rule.eventbridge_rule.name
  arn       = aws_sns_topic.sns_topic.arn
}

resource "aws_iam_role" "eventbridge_sns_role" {
  name = var.event_bridge_sns_role_name

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": ["events.amazonaws.com"]
      },
      "Action": ["sts:AssumeRole"]
    }
  ]
}
EOF
}

resource "aws_iam_policy_attachment" "eventbridge_policy_attachment" {
   name = "policy_attachment"
   policy_arn = "arn:aws:iam::aws:policy/AmazonSNSFullAccess"
   roles      = [aws_iam_role.eventbridge_sns_role.name]
}
