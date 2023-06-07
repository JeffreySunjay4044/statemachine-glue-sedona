provider "aws" {
  region = var.aws_region
}

locals {
  default_tags = {
    "application" = var.application,
    "env"         = var.aws_environment_name,
    "provider"    = "aws"
  }

  tags = merge(local.default_tags, var.tags)
}

# ---------------------------------------------------------------------------------------------------------------------
# Glue Crawler
# ---------------------------------------------------------------------------------------------------------------------

module "glue_crawler" {
  source = "../submodules/glue-components/glue-crawler"
  count  = var.enable_destination_crawler ? 1 : 0

  application          = var.application
  aws_environment_name = var.aws_environment_name
  aws_region           = var.aws_region
  database_name        = var.processed_glue_database_name
  name                 = "${var.phase_name}-${var.phase_output_path}"
  role                 = aws_iam_role.glue_role.name
  s3_targets           = [{ path = "s3://${var.data_lake_bucket}/${var.phase_output_path}/" }]
  tags                 = local.tags
  target               = "S3"

  configuration_string = jsonencode({
    CrawlerOutput = {
      Partitions = { AddOrUpdateBehavior = "InheritFromTable" }
      Tables     = { AddOrUpdateBehavior = "MergeNewColumns" }
    }
    Version = 1
  })
}

# ---------------------------------------------------------------------------------------------------------------------
# Glue Job
# ---------------------------------------------------------------------------------------------------------------------

module "glue_job" {
  source = "../submodules/glue-etl-job-shim"

  additional_python_modules = var.glue_job_python_modules
  application               = var.application
  aws_account_id            = var.aws_account_id
  aws_environment_name      = var.aws_environment_name
  aws_region                = var.aws_region
  connection                = var.glue_network_connection_name
  default_arguments         = var.glue_job_default_arguments
  enable_bookmarking        = var.glue_job_enable_bookmarking
  glue_scripts_path         = var.glue_scripts_path
  glue_version              = var.glue_version
  max_retries               = 0
  name                      = var.phase_name
  number_of_workers         = var.glue_job_number_of_workers
  pip_index_url             = var.pip_index_url
  resources_bucket          = var.resources_bucket
  role_arn                  = aws_iam_role.glue_role.arn
  tags                      = local.tags
  temp_directory            = "s3://${var.temp_bucket}"
  timeout                   = var.glue_job_timeout
  worker_type               = var.glue_job_worker_type
  job_entry_point           = var.job_entry_point
}

# ---------------------------------------------------------------------------------------------------------------------
# IAM Role for the Glue Job
# ---------------------------------------------------------------------------------------------------------------------

data "aws_iam_policy_document" "s3_policy" {
  statement {
    actions = ["s3:ListBucket"]
    effect  = "Allow"
    resources = [
      "arn:aws:s3:::${var.data_lake_bucket}",
      "arn:aws:s3:::${var.temp_bucket}"
    ]
  }

  statement {
    actions = [
      "s3:PutObject",
      "s3:GetObject",
      "s3:DeleteObject"
    ]
    effect = "Allow"
    resources = [
      "arn:aws:s3:::${var.data_lake_bucket}/*",
      "arn:aws:s3:::${var.temp_bucket}/*"
    ]
  }

  statement {
    actions   = ["s3:GetObject"]
    effect    = "Allow"
    resources = ["arn:aws:s3:::${var.resources_bucket}/${var.glue_scripts_path}/*"]
  }
}

data "aws_iam_policy_document" "glue_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      identifiers = ["glue.amazonaws.com"]
      type        = "Service"
    }
  }
}

resource "aws_iam_role" "glue_role" {
  assume_role_policy  = data.aws_iam_policy_document.glue_assume_role_policy.json
  managed_policy_arns = ["arn:aws:iam::aws:policy/service-role/AWSGlueServiceRole"]
  name                = "${var.application}-${var.aws_environment_name}-${var.phase_name}-glue"
  tags                = local.tags

  inline_policy {
    name   = "s3_policy"
    policy = data.aws_iam_policy_document.s3_policy.json
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# State Machine
# ---------------------------------------------------------------------------------------------------------------------


variable "cities_csv_path" {
  default = ""
}
variable "states_wkt_path" {
  default = ""
}
module "state_machine" {
  source = "../submodules/state-machines/run-sedona-job"

  application                   = var.application
  aws_account_id                = var.aws_account_id
  aws_environment_name          = var.aws_environment_name
  aws_region                    = var.aws_region
  name                          = var.phase_name
  tags                          = local.tags
  glue_crawler_prefix = var.glue_crawler_prefix
  glue_job_name                 = module.glue_job.glue_job_name
  states_wkt_path               = var.states_wkt_path
  cities_csv_path =  var.cities_csv_path
}
