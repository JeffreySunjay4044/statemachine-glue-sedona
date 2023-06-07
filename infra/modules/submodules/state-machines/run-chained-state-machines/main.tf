locals {
  default_tags = {
    "application" = var.application,
    "env"         = var.aws_environment_name,
    "provider"    = "aws"
  }

  name = replace(lower("${var.application}-${var.aws_environment_name}-${var.name}"), " ", "-")
  tags = merge(local.default_tags, var.tags)
}

# ---------------------------------------------------------------------------------------------------------------------
# State Machine
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_sfn_state_machine" "state_machine" {
  definition = jsonencode(yamldecode(templatefile("${path.module}/run-chained-state-machines-sfn.yaml", {
    state_machine_arns = var.state_machine_arns
  })))
  logging_configuration {
    include_execution_data = true
    level                  = "ALL"
    log_destination        = "${aws_cloudwatch_log_group.state_machine_log_group.arn}:*"
  }
  name     = local.name
  role_arn = aws_iam_role.state_machine_role.arn
  tags     = local.tags
}

# ---------------------------------------------------------------------------------------------------------------------
# State Machine Log Group
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_cloudwatch_log_group" "state_machine_log_group" {
  name              = "/aws/vendedlogs/states/${local.name}"
  retention_in_days = var.retention_in_days
  tags              = local.tags
}

# ---------------------------------------------------------------------------------------------------------------------
# State Machine IAM Role and Policies
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_iam_role" "state_machine_role" {
  assume_role_policy = data.aws_iam_policy_document.state_machine_assume_role_policy.json

  inline_policy {
    name   = "base_policy"
    policy = data.aws_iam_policy_document.state_machine_base_policy.json
  }

  inline_policy {
    name   = "states_policy"
    policy = data.aws_iam_policy_document.state_machine_states_policy.json
  }

  name = "${local.name}-sfn"
  tags = local.tags
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

data "aws_iam_policy_document" "state_machine_states_policy" {
  statement {
    actions = [
      "states:DescribeExecution",
      "states:StopExecution"
    ]
    effect    = "Allow"
    resources = [for arn in var.state_machine_arns : "${replace(arn, ":stateMachine:", ":execution:")}:*"]
  }
  statement {
    actions   = ["states:StartExecution"]
    effect    = "Allow"
    resources = var.state_machine_arns
  }
}
