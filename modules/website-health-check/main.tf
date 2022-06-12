terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      configuration_aliases = [aws.default, aws.us-east-1]
    }  
  }
}

variable "fqdn" {
  type = string
}

variable "sns_arn" {
  type = string
}

resource "aws_route53_health_check" "check" {
  provider = aws.us-east-1
  fqdn = var.fqdn
  port = 80
  type = "HTTP"
  resource_path = "/"
  failure_threshold = 5
  request_interval = 30
  tags = {
    Name = "${var.fqdn} Liveness Check"
  }
}

resource "aws_cloudwatch_metric_alarm" "alarm" {
  provider = aws.us-east-1
  alarm_name          = "${var.fqdn} Liveness Check"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "HealthCheckStatus"
  namespace           = "AWS/Route53"
  period              = "300"
  statistic           = "Average"
  threshold           = "1"
  alarm_description   = "This metrics monitors whether the relevant domain is available."
  dimensions = {
    HealthCheckId = aws_route53_health_check.check.id
  }
  alarm_actions = [var.sns_arn]
  ok_actions = [var.sns_arn]
}
