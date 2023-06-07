locals {
  default_tags = {
    "application" = var.application,
    "env"         = var.aws_environment_name,
    "provider"    = "aws"
  }

  name        = replace(lower("${var.application}-${var.aws_environment_name}-${var.name}"), " ", "-")
  tags        = merge(local.default_tags, var.tags)
}

# State Machine

variable "states_wkt_path" {
  default = ""
}
variable "cities_csv_path" {
  default = ""
}
data "template_file" "state_machine_definition" {
  template = file("${path.module}/run-sedona-job-sfn.yaml")
  vars = {
    glue_job_name                   = var.glue_job_name
    cities_csv_path                 = var.cities_csv_path
    states_wkt_path                 = var.states_wkt_path
    max_task_concurrency            = max(var.max_glue_concurrency - var.reserve_glue_concurrency, 1)
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
      })
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

