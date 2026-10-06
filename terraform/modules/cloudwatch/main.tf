locals {
  alb_suffix = join("/", slice(split("/", var.alb_arn), 1, 4))

  target_group_suffix = join(
    "/",
    slice(split("/", var.target_group_arn), 1, 3)
  )
}

resource "aws_cloudwatch_dashboard" "main" {
  dashboard_name = "${var.project_name}-${var.environment}-observability"

  dashboard_body = jsonencode({
    widgets = [
      {
        type   = "text"
        x      = 0
        y      = 0
        width  = 24
        height = 2

        properties = {
          markdown = <<-EOT
            # CloudTicket V2 Observability

            **Architecture:** CloudFront + WAF → HTTPS ALB → ASG → RDS PostgreSQL

            **Region:** ${var.aws_region}
          EOT
        }
      },

      {
        type   = "metric"
        x      = 0
        y      = 2
        width  = 12
        height = 6

        properties = {
          title  = "ALB Request Count"
          region = var.aws_region
          stat   = "Sum"
          period = 300

          metrics = [
            [
              "AWS/ApplicationELB",
              "RequestCount",
              "LoadBalancer",
              local.alb_suffix
            ]
          ]
        }
      },

      {
        type   = "metric"
        x      = 12
        y      = 2
        width  = 12
        height = 6

        properties = {
          title  = "ALB Target Response Time"
          region = var.aws_region
          stat   = "Average"
          period = 300

          metrics = [
            [
              "AWS/ApplicationELB",
              "TargetResponseTime",
              "LoadBalancer",
              local.alb_suffix
            ]
          ]
        }
      },

      {
        type   = "metric"
        x      = 0
        y      = 8
        width  = 12
        height = 6

        properties = {
          title  = "ALB Target 5XX Errors"
          region = var.aws_region
          stat   = "Sum"
          period = 300

          metrics = [
            [
              "AWS/ApplicationELB",
              "HTTPCode_Target_5XX_Count",
              "LoadBalancer",
              local.alb_suffix
            ]
          ]
        }
      },

      {
        type   = "metric"
        x      = 12
        y      = 8
        width  = 12
        height = 6

        properties = {
          title  = "Healthy Targets"
          region = var.aws_region
          stat   = "Minimum"
          period = 300

          metrics = [
            [
              "AWS/ApplicationELB",
              "HealthyHostCount",
              "LoadBalancer",
              local.alb_suffix,
              "TargetGroup",
              local.target_group_suffix
            ]
          ]
        }
      },

      {
        type   = "metric"
        x      = 0
        y      = 14
        width  = 12
        height = 6

        properties = {
          title  = "ASG Capacity"
          region = var.aws_region
          stat   = "Average"
          period = 300

          metrics = [
            [
              "AWS/AutoScaling",
              "GroupDesiredCapacity",
              "AutoScalingGroupName",
              var.autoscaling_group_name
            ],
            [
              "AWS/AutoScaling",
              "GroupInServiceInstances",
              "AutoScalingGroupName",
              var.autoscaling_group_name
            ]
          ]
        }
      },

      {
        type   = "metric"
        x      = 12
        y      = 14
        width  = 12
        height = 6

        properties = {
          title  = "RDS Database Connections"
          region = var.aws_region
          stat   = "Average"
          period = 300

          metrics = [
            [
              "AWS/RDS",
              "DatabaseConnections",
              "DBInstanceIdentifier",
              var.db_instance_id
            ]
          ]
        }
      },

      {
        type   = "metric"
        x      = 0
        y      = 20
        width  = 12
        height = 6

        properties = {
          title  = "RDS Free Storage"
          region = var.aws_region
          stat   = "Minimum"
          period = 300
          view   = "timeSeries"

          metrics = [
            [
              "AWS/RDS",
              "FreeStorageSpace",
              "DBInstanceIdentifier",
              var.db_instance_id
            ]
          ]

          yAxis = {
            left = {
              label = "Bytes"
            }
          }
        }
      },

      {
        type   = "metric"
        x      = 12
        y      = 20
        width  = 12
        height = 6

        properties = {
          title  = "WAF Allowed vs Blocked Requests"
          region = "us-east-1"
          stat   = "Sum"
          period = 300

          metrics = [
            [
              "AWS/WAFV2",
              "AllowedRequests",
              "WebACL",
              var.waf_web_acl_name,
              "Rule",
              "ALL",
              "Region",
              "CloudFront"
            ],
            [
              ".",
              "BlockedRequests",
              "WebACL",
              var.waf_web_acl_name,
              "Rule",
              "ALL",
              "Region",
              "CloudFront"
            ]
          ]
        }
      }
    ]
  })
}


# CloudWatch Alarms

resource "aws_cloudwatch_metric_alarm" "alb_target_5xx" {
  alarm_name          = "${var.project_name}-${var.environment}-alb-target-5xx"
  alarm_description   = "Alarm when the ALB backend returns 5XX responses"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "HTTPCode_Target_5XX_Count"
  namespace           = "AWS/ApplicationELB"
  period              = 300
  statistic           = "Sum"
  threshold           = 0

  dimensions = {
    LoadBalancer = local.alb_suffix
  }

  treat_missing_data = "notBreaching"
}


resource "aws_cloudwatch_metric_alarm" "alb_unhealthy_hosts" {
  alarm_name          = "${var.project_name}-${var.environment}-alb-unhealthy-hosts"
  alarm_description   = "Alarm when one or more ALB targets become unhealthy"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "UnHealthyHostCount"
  namespace           = "AWS/ApplicationELB"
  period              = 300
  statistic           = "Maximum"
  threshold           = 0

  dimensions = {
    LoadBalancer = local.alb_suffix
    TargetGroup  = local.target_group_suffix
  }

  treat_missing_data = "notBreaching"
}


resource "aws_cloudwatch_metric_alarm" "asg_inservice_instances" {
  alarm_name          = "${var.project_name}-${var.environment}-asg-inservice-instances"
  alarm_description   = "Alarm when the Auto Scaling Group has fewer than two in-service instances"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 2
  metric_name         = "GroupInServiceInstances"
  namespace           = "AWS/AutoScaling"
  period              = 300
  statistic           = "Minimum"
  threshold           = 2

  dimensions = {
    AutoScalingGroupName = var.autoscaling_group_name
  }

  treat_missing_data = "notBreaching"
}


resource "aws_cloudwatch_metric_alarm" "rds_free_storage" {
  alarm_name          = "${var.project_name}-${var.environment}-rds-free-storage"
  alarm_description   = "Alarm when RDS free storage falls below 5 GiB"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 2
  metric_name         = "FreeStorageSpace"
  namespace           = "AWS/RDS"
  period              = 300
  statistic           = "Minimum"
  threshold           = 5 * 1024 * 1024 * 1024

  dimensions = {
    DBInstanceIdentifier = var.db_instance_id
  }

  treat_missing_data = "notBreaching"
}
