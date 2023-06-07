# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# DEPLOY AN AWS GLUE CRAWLER
# This template deploy an AWS glue crawler.
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# ---------------------------------------------------------------------------------------------------------------------
# Create an AWS Glue Crawler
# ---------------------------------------------------------------------------------------------------------------------

locals {
  default_tags = {
    "application" = var.application,
    "env"         = var.aws_environment_name,
    "provider"    = "aws"
  }

  name = replace(lower("${var.application}-${var.aws_environment_name}-${var.name}-${var.target}"), " ", "-")

  configuration_string = var.configuration_string != "" ? var.configuration_string : jsonencode(var.configuration)
  jdbc_targets         = var.jdbc_include_path != "" ? [{ path = var.jdbc_include_path }] : var.jdbc_targets

  # Merge the default tags with any extra passed in by the user into a single map
  tags = merge(local.default_tags, var.tags)
}

resource "aws_glue_crawler" "glue_crawler_dynamodb" {
  count = var.target == "DynamoDB" ? 1 : 0

  configuration = local.configuration_string
  database_name = var.database_name
  description   = var.description
  name          = local.name
  role          = var.role
  schedule      = var.schedule
  table_prefix  = var.table_prefix
  tags          = local.tags

  schema_change_policy {
    delete_behavior = var.delete_behavior
    update_behavior = var.update_behavior
  }

  dynamic "dynamodb_target" {
    for_each = var.dynamodb_targets
    content {
      path      = dynamodb_target.value["path"]
      scan_all  = lookup(dynamodb_target.value, "scan_all", true)
      scan_rate = lookup(dynamodb_target.value, "scan_rate", null)
    }
  }
}

resource "aws_glue_crawler" "glue_crawler_s3" {
  count = var.target == "S3" ? 1 : 0

  classifiers   = var.classifiers
  configuration = local.configuration_string
  database_name = var.database_name
  description   = var.description
  name          = local.name
  role          = var.role
  schedule      = var.schedule
  table_prefix  = var.table_prefix
  tags          = local.tags

  schema_change_policy {
    delete_behavior = var.delete_behavior
    update_behavior = var.update_behavior
  }

  dynamic "s3_target" {
    for_each = var.s3_targets
    content {
      connection_name = var.target_connection_name
      exclusions      = var.target_exclusions != "" ? split(",", trim(var.target_exclusions, " ")) : []
      path            = s3_target.value["path"]
    }
  }
}

resource "aws_glue_crawler" "glue_crawler_jdbc" {
  count = var.target == "JDBC" ? 1 : 0

  configuration = local.configuration_string
  database_name = var.database_name
  description   = var.description
  name          = local.name
  role          = var.role
  schedule      = var.schedule
  table_prefix  = var.table_prefix
  tags          = local.tags

  schema_change_policy {
    delete_behavior = var.delete_behavior
    update_behavior = var.update_behavior
  }

  dynamic "jdbc_target" {
    for_each = local.jdbc_targets
    content {
      connection_name = var.target_connection_name
      exclusions      = var.target_exclusions != "" ? split(",", trim(var.target_exclusions, " ")) : []
      path            = jdbc_target.value["path"]
    }
  }
}
