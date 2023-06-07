# ---------------------------------------------------------------------------------------------------------------------
# CREATE A STATE MACHINE TO RUN CRAWLER
# ---------------------------------------------------------------------------------------------------------------------

locals {
  default_tags = {
    "application" = var.application,
    "env"         = var.aws_environment_name,
    "provider"    = "aws"
  }

  name = replace(lower("${var.application}-${var.aws_environment_name}-${var.name}"), " ", "-")
  # Merge the default tags with any extra passed in by the user into a single map
  tags = merge(local.default_tags, var.tags)
}

# ---------------------------------------------------------------------------------------------------------------------
# CREATE IAM RESOURCES FOR STATE MACHINE
# ---------------------------------------------------------------------------------------------------------------------

data "aws_iam_policy_document" "sfn_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      identifiers = ["states.${var.aws_region}.amazonaws.com"]
      type        = "Service"
    }
  }
}

resource "aws_iam_role" "sfn_exec_role" {
  assume_role_policy = data.aws_iam_policy_document.sfn_assume_role.json
  name               = "${local.name}-sfn"
}

data "aws_iam_policy_document" "sfn_exec_policy_document" {
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
      "glue:GetCrawler",
      "glue:StartCrawler"
    ]
    effect = "Allow"
    resources = [
      "arn:aws:glue:${var.aws_region}:${var.aws_account_id}:crawler/${var.glue_crawler_prefix}*"
    ]
  }
}

# TODO: Make this an inline policy
resource "aws_iam_policy" "sfn_policy" {
  name   = "${var.application}-run-crawler-sfn-policy"
  policy = data.aws_iam_policy_document.sfn_exec_policy_document.json
}

resource "aws_iam_role_policy_attachment" "sfn_role_policy_attachment" {
  policy_arn = aws_iam_policy.sfn_policy.arn
  role       = aws_iam_role.sfn_exec_role.name
}

# ---------------------------------------------------------------------------------------------------------------------
# CREATE RUN CRAWLER STATE MACHINE
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_sfn_state_machine" "run_crawler_state_machine" {
  definition = jsonencode(yamldecode(file("${path.module}/run-crawler-sfn.yaml")))
  name       = local.name
  role_arn   = aws_iam_role.sfn_exec_role.arn
  logging_configuration {
    include_execution_data = true
    level                  = "ALL"
    log_destination        = "${aws_cloudwatch_log_group.run_crawler_log_group.arn}:*"
  }
  tags = local.tags
}

# ---------------------------------------------------------------------------------------------------------------------
# CREATE RUN CRAWLER STATE MACHINE LOG GROUP
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_cloudwatch_log_group" "run_crawler_log_group" {
  name              = "/aws/vendedlogs/states/${local.name}"
  retention_in_days = var.retention_in_days
  tags              = local.tags
}
