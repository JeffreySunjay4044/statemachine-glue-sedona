# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# DEPLOY AN AWS GLUE JOB
# This template deploys an AWS job.
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# ---------------------------------------------------------------------------------------------------------------------
# Create an AWS Glue job
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

resource "aws_glue_job" "glue_job" {
  connections               = var.connections
  default_arguments         = var.default_arguments
  description               = var.description
  glue_version              = var.glue_version
  max_capacity              = var.max_capacity
  max_retries               = var.max_retries
  name                      = local.name
  non_overridable_arguments = var.non_overridable_arguments
  number_of_workers         = var.number_of_workers
  role_arn                  = var.role_arn
  tags                      = local.tags
  timeout                   = var.timeout
  worker_type               = var.worker_type

  command {
    name            = var.job_type
    python_version  = var.python_version
    script_location = var.script_location
  }

  execution_property {
    max_concurrent_runs = var.max_concurrent_runs
  }
}
