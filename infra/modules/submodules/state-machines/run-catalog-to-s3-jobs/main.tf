locals {
  default_tags = {
    "application" = var.application,
    "env"         = var.aws_environment_name,
    "provider"    = "aws"
  }

  run_crawler = var.run_source_crawler || var.run_destination_crawler
  name        = replace(lower("${var.application}-${var.aws_environment_name}-${var.name}"), " ", "-")
  tags        = merge(local.default_tags, var.tags)
}

# State Machine

data "template_file" "state_machine_definition" {
  template = file("${path.module}/run-catalog-to-s3-jobs-sfn.yaml")
  vars = {
    destination_glue_crawler_name   = var.destination_glue_crawler_name != null ? var.destination_glue_crawler_name : "NOT_PROVIDED"
    destination_path_prefix         = var.destination_s3_uri_prefix
    get_tables_lambda_arn           = var.get_tables_lambda_arn
    glue_job_name                   = var.glue_job_name
    glue_job_run_waiter_seconds     = var.glue_job_run_waiter_seconds
    glue_job_retry_interval_seconds = var.glue_job_retry_interval_seconds
    max_task_concurrency            = max(var.max_glue_concurrency - var.reserve_glue_concurrency, 1)
    run_crawler_state_machine_arn   = var.run_crawler_state_machine_arn
    should_run_destination_crawler  = var.run_destination_crawler
    should_run_source_crawler       = var.run_source_crawler
    source_glue_crawler_name        = var.source_glue_crawler_name != null ? var.source_glue_crawler_name : "NOT_PROVIDED"
    source_glue_database_name       = var.source_glue_database_name
  }
}

resource "aws_sfn_state_machine" "state_machine" {
  definition = jsonencode(yamldecode(data.template_file.state_machine_definition.rendered))
  logging_configuration {
    include_execution_data = true
    level                  = "ALL"
    log_destination        = "${aws_cloudwatch_log_group.state_machine_log_group.arn}:*"
  }
  name     = local.name
  role_arn = aws_iam_role.state_machine_role.arn
}

# State Machine Log Group

resource "aws_cloudwatch_log_group" "state_machine_log_group" {
  name              = "/aws/vendedlogs/states/${local.name}"
  retention_in_days = var.retention_in_days
  tags              = local.tags
}

# State Machine IAM Role and Policies

resource "aws_iam_role" "state_machine_role" {
  assume_role_policy = data.aws_iam_policy_document.state_machine_assume_role_policy.json

  dynamic "inline_policy" {
    for_each = merge({
      base_policy   = data.aws_iam_policy_document.state_machine_base_policy.json
      glue_policy   = data.aws_iam_policy_document.state_machine_glue_policy.json
      lambda_policy = data.aws_iam_policy_document.state_machine_lambda_policy.json
      }, local.run_crawler ? {
      run_crawler_policy = data.aws_iam_policy_document.state_machine_run_crawler_policy[0].json
    } : {})
    content {
      name   = inline_policy.key
      policy = inline_policy.value
    }
  }

  name = "${local.name}-sfn"
}

data "aws_iam_policy_document" "state_machine_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      identifiers = ["states.${var.aws_region}.amazonaws.com"]
      type        = "Service"
    }
  }
}

data "aws_iam_policy_document" "state_machine_base_policy" {
  statement {
    actions = [
      "logs:CreateLogDelivery",
      "logs:DeleteLogDelivery",
      "logs:DescribeLogGroups",
      "logs:DescribeResourcePolicies",
      "logs:GetLogDelivery",
      "logs:ListLogDeliveries",
      "logs:PutResourcePolicy",
      "logs:UpdateLogDelivery"
    ]
    effect    = "Allow"
    resources = ["*"]
  }
  statement {
    actions = [
      "events:DescribeRule",
      "events:PutRule",
      "events:PutTargets"
    ]
    effect    = "Allow"
    resources = ["arn:aws:events:${var.aws_region}:${var.aws_account_id}:rule/StepFunctionsGetEventsForStepFunctionsExecutionRule"]
  }
}

data "aws_iam_policy_document" "state_machine_glue_policy" {
  statement {
    actions = [
      "glue:BatchStopJobRun",
      "glue:GetJobRun",
      "glue:GetJobRuns",
      "glue:StartJobRun"
    ]
    effect    = "Allow"
    resources = ["*"]
  }
}

data "aws_iam_policy_document" "state_machine_lambda_policy" {
  statement {
    actions = [
      "lambda:InvokeFunction"
    ]
    effect    = "Allow"
    resources = [var.get_tables_lambda_arn]
  }
}

data "aws_iam_policy_document" "state_machine_run_crawler_policy" {
  count = local.run_crawler ? 1 : 0
  statement {
    actions = [
      "states:DescribeExecution",
      "states:StopExecution"
    ]
    effect    = "Allow"
    resources = ["${replace(var.run_crawler_state_machine_arn, ":stateMachine:", ":execution:")}:*"]
  }
  statement {
    actions   = ["states:StartExecution"]
    effect    = "Allow"
    resources = [var.run_crawler_state_machine_arn]
  }
}
