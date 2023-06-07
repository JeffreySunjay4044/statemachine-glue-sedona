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
# Sedona Processing S3
# ---------------------------------------------------------------------------------------------------------------------

module "sedona-processing-s3" {
  source = "../../modules/sedona-processing-simple-s3"
  application = var.application
  aws_account_id = var.aws_account_id
  aws_environment_name = var.aws_environment_name
  aws_region = var.aws_region
  data_lake_bucket = var.data_lake_bucket
  glue_crawler_prefix = var.glue_crawler_prefix
  glue_job_python_modules = var.glue_job_python_modules
  glue_network_connection_name = var.glue_network_connection_name
  resources_bucket = var.resources_bucket
  tags = var.tags
  temp_bucket = var.temp_bucket
  job_entry_point = var.job_entry_point
  cities_wkt_s3_path = var.cities_wkt_s3_path
  states_wkt_s3_path = var.states_wkt_s3_path
}

module "sedona-processing-simple-s3" {
  source = "../../modules/sedona-processing-simple-s3"
  application = var.application
  aws_account_id = var.aws_account_id
  aws_environment_name = var.aws_environment_name
  aws_region = var.aws_region
  data_lake_bucket = var.data_lake_bucket
  glue_crawler_prefix = var.glue_crawler_prefix
  glue_job_python_modules = var.glue_job_python_modules
  glue_network_connection_name = var.glue_network_connection_name
  resources_bucket = var.resources_bucket
  tags = var.tags
  temp_bucket = var.temp_bucket
  job_entry_point = "Sedonalogicjob2.py"
  cities_wkt_s3_path = var.cities_wkt_s3_path
  states_wkt_s3_path = var.states_wkt_s3_path
}

module "sedona-processing-simple-s3" {
  source = "../../modules/sedona-processing-simple-s3"
  application = var.application
  aws_account_id = var.aws_account_id
  aws_environment_name = var.aws_environment_name
  aws_region = var.aws_region
  data_lake_bucket = var.data_lake_bucket
  glue_crawler_prefix = var.glue_crawler_prefix
  glue_job_python_modules = var.glue_job_python_modules
  glue_network_connection_name = var.glue_network_connection_name
  resources_bucket = var.resources_bucket
  tags = var.tags
  temp_bucket = var.temp_bucket
  job_entry_point = var.sedona_agg_job_entry_point
  cities_wkt_s3_path = var.cities_wkt_s3_path
  states_wkt_s3_path = var.states_wkt_s3_path
}