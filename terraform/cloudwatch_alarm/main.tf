resource "aws_cloudwatch_metric_alarm" "cpu_util_alarm" {
  alarm_name          = "CPU Utiliaztion Alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 120
  statistic           = "Average"
  threshold           = "80"
  alarm_description   = "Alarm if CPU exceeds 80% for 2 consecutive periods"
  actions_enabled     = true

  dimensions = {
    InstanceId = var.instance_id
  }

  alarm_actions = [aws_sns_topic.cpu_util_alarm_topic.arn]
}

resource "aws_iam_policy" "cpu_util_alarm_policy" {
  name        = "CloudWatchAlarmPolicy"
  description = "IAM policy for CloudWatch Alarms"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = [
        "SNS:Publish"
      ],
      Effect   = "Allow",
      Resource = aws_sns_topic.cpu_util_alarm_topic.arn
    }]
  })
}

resource "aws_iam_role" "cpu_util_alarm_role" {
  name = "cpu_util_alarm_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = {
        Service = "cloudwatch.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "cpu_util_alarm_role_policy_attachement" {
  policy_arn = aws_iam_policy.cpu_util_alarm_policy.arn
  role       = aws_iam_role.cpu_util_alarm_role.name
}

resource "aws_sns_topic" "cpu_util_alarm_topic" {
  name = "cpu_util_alarm_topic"
}

resource "aws_sns_topic_subscription" "cpu_util_alarm_subs" {
  topic_arn = aws_sns_topic.cpu_util_alarm_topic.arn
  protocol  = "email"
  endpoint  = var.email
}

resource "aws_cloudwatch_log_group" "cpu_util_alarm_log_group" {
  name              = "/var/log/messages"
  retention_in_days = 14
}

resource "aws_cloudwatch_log_stream" "cpu_util_alarm_log_stream" {
  name           = "cpu_util_alarm_log_stream"
  log_group_name = aws_cloudwatch_log_group.cpu_util_alarm_log_group.name
}