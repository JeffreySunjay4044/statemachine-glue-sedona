locals {
  default_tags = {
    "application" = var.application
    "env"         = var.aws_environment_name
    "provider"    = "aws"
  }

  glue_args_base = {
    "--TempDir"                          = length(var.temp_directory) > 0 ? var.temp_directory : "s3://aws-glue-temporary-${var.aws_account_id}-${var.aws_region}"
    "--enable-auto-scaling"              = var.enable_auto_scaling && contains(["G.1X", "G.2X"], var.worker_type)
    "--enable-continuous-cloudwatch-log" = true
    "--enable-glue-datacatalog"          = ""
    "--enable-metrics"                   = ""
    "--enable-s3-parquet-optimized-committer" = true
    "--job-bookmark-option"              = var.enable_bookmarking ? "job-bookmark-enable" : "job-bookmark-disable"
    "--job-language"                     = "python"
    "--job_entry_point"                  = var.job_entry_point
  }

  glue_arg_additional_modules = length(var.additional_python_modules) == 0 ? {} : {
    "--additional-python-modules" = join(",", var.additional_python_modules)
  }

  # Find way to pull from private pypi module
  glue_arg_installer_options = length(var.pip_extra_index_urls) == 0 ? {
    "--python-modules-installer-option" = "--index-url=${var.pip_index_url}"
  } : {
    "--python-modules-installer-option" = "--index-url=${var.pip_index_url} --extra-index-url=${join(",", var.pip_extra_index_urls)}"
  }

  # Merge the various Glue arguments with the args passed in by the user. User-provided arguments will override the others.
  glue_args_final = merge(
    local.glue_args_base,
    local.glue_arg_additional_modules,
    local.glue_arg_installer_options,
    var.default_arguments
  )

  # Merge the default tags with any extra passed in by the user into a single map.
  tags = merge(local.default_tags, var.tags)
}

module "shim_script" {
  source               = "../glue-shim-script"
  application          = var.application
  aws_account_id       = var.aws_account_id
  aws_environment_name = var.aws_environment_name
  aws_region           = var.aws_region
  name                 = var.name
  resources_bucket     = var.resources_bucket
  tags                 = local.tags
}

module "glue_job" {
  source               = "../glue-components/glue-job"
  application          = var.application
  aws_environment_name = var.aws_environment_name
  aws_region           = var.aws_region
  connections          = [var.connection]
  default_arguments    = local.glue_args_final
  description          = var.description
  glue_version         = var.glue_version
  max_concurrent_runs  = var.max_concurrent_runs
  name                 = var.name
  number_of_workers    = var.number_of_workers
  role_arn             = var.role_arn
  script_location      = module.shim_script.script_location
  tags                 = local.tags
  timeout              = var.timeout
  worker_type          = var.worker_type
}
