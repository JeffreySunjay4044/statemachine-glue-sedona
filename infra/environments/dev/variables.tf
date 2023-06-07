variable "application" {
  description = "The name of the application."
  type        = string
  default     = "application"
}

variable "aws_account_id" {
  description = "The ID of the AWS Account in which to create resources."
  type        = string
  default     = "655275087384"
}

variable "aws_environment_name" {
  description = "The name of the AWS environment (development, staging, production)."
  type        = string
  default     = "development"
}

variable "aws_region" {
  description = "The AWS region in which all resources will be created."
  type        = string
  default     = "us-east-1"
}

variable "data_lake_bucket" {
  description = "The name of the data lake S3 bucket."
  type        = string
  default     = "data-lake-bucket"
}

variable "job_entry_point" {
  description = "The Python module and class name of the job entry point, provided in the form 'module:Class' (e.g., 'allied_glue_jobs.catalog_to_s3_job:CatalogToS3Job')."
  type        = string
  default     = "nexteraa_glue_jobs.sedona_logic_job:SedonaLogicJob"
}

variable "states_wkt_s3_path" {
  description = "The S3 path of the CSV file."
  type        = string
  default     = "s3://glue-sedona/data/customers_database/country_csv/boundary-each-state.tsv"
}

variable "cities_wkt_s3_path" {
  description = "The S3 path of the CSV file."
  type        = string
  default     = "s3://glue-sedona/data/customers_database/country_csv/cities.csv"
}

variable "glue_crawler_prefix" {
  description = "The prefix of the Glue crawler."
  type        = string
  default     = "crawler-prefix"
}

variable "glue_job_python_modules" {
  description = "A list of Python modules to include in the optimization Glue Job."
  type        = list(string)
  default     = []
}

variable "glue_network_connection_name" {
  description = "The name of the network-type Glue Connection for this data lake."
  type        = string
  default     = "network-connection"
}

variable "resources_bucket" {
  description = "The name of the resources S3 bucket."
  type        = string
  default     = "dmpprospecttesttf"
}

variable "temp_bucket" {
  description = "The name of the temporary S3 bucket."
  type        = string
  default     = "temp-bucket"
}

variable "tags" {
  description = "A key-value map of resource tags."
  type        = map(any)
  default     = {}
}
