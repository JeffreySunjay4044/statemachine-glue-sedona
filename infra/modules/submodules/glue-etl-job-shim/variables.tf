variable "additional_python_modules" {
  default     = ["apache-sedona==1.4.0"]
  description = "List of additional Python modules to include in the Glue Job. Defaults to ['allied_world_glue']. Use 'pip_extra_index_url' to access modules in private repositories."
  type        = list(string)
}

variable "application" {
  description = "The name of the application. This is used as a prefix for the Glue Job name, and for AWS resource tags."
  type        = string
}

variable "aws_account_id" {
  description = "The ID of the AWS Account in which to create resources."
  type        = string
}

variable "aws_environment_name" {
  description = "The name of the AWS environment (development, staging, production)."
  type        = string
}

variable "aws_region" {
  description = "The AWS region in which all resources will be created."
  type        = string
}

variable "connection" {
  description = "Glue connection name to be used for this job."
  type        = string
}

variable "default_arguments" {
  default     = {}
  description = "The default arguments for this Glue job, supplied as a map of key/value pairs. This map will be preferentially merged with a map of base arguments."
  type        = map(string)
}

variable "description" {
  default     = ""
  description = "The description of the job."
  type        = string
}

variable "enable_auto_scaling" {
  default     = true
  description = "Enable Glue auto-scaling for the job, if using a compatible worker type (G.1X or G.2X). Defaults to true."
  type        = bool
}

variable "enable_bookmarking" {
  default     = false
  description = "Enable Glue bookmarking (e.g., continuations) for the job. Defaults to false."
  type        = bool
}

variable "glue_scripts_path" {
  default     = "glue-scripts"
  description = "The path (in the resources S3 bucket) where Glue scripts are stored."
  type        = string
}

variable "glue_version" {
  default     = "3.0"
  description = "The version of the Glue runtime to use."
  type        = string
  validation {
    condition     = contains(["2.0", "3.0"], var.glue_version)
    error_message = "The glue_version value must be either '2.0' or '3.0'."
  }
}

variable "job_entry_point" {
  description = "The Python module and class name of the job entry point, provided in the form 'module:Class' (e.g., 'allied_glue_jobs.catalog_to_s3_job:CatalogToS3Job')."
  type        = string
}

variable "states_wkt_s3_path" {
  description = "The S3 path of the CSV file."
  type        = string
}

variable "cities_wkt_s3_path" {
  description = "The S3 path of the CSV file."
  type        = string
}

variable "max_concurrent_runs" {
  default     = 1
  description = "The maximum number of concurrent runs allowed for a job. Defaults to 1."
  type        = number
}

variable "max_retries" {
  default     = 0
  description = "The maximum number of times to retry this job if it fails. Defaults to 0."
  type        = number
}

variable "pip_extra_index_urls" {
  default     = ["https://pypi.org/simple"]
  description = "A list of URLs of PyPi-compatible package repositories, to be passed to the 'pip' command when running a Glue job. Defaults to [] (empty)."
  type        = list(string)
}

variable "pip_index_url" {
  default     = "https://dbuescrz28.execute-api.us-east-1.amazonaws.com/prod/pypi/allied_world_glue/simple/"
  description = "The URL of a PyPi-compatible package repository, to be used in place of the default public PyPi repository."
  type        = string
}

variable "name" {
  description = "The name assigned to the Glue job. It must be unique in your application."
  type        = string
}

variable "number_of_workers" {
  default     = 4
  description = "The number of workers that are allocated when a job runs."
  type        = number
}

variable "role_arn" {
  description = "The ARN of the IAM role associated with this job."
  type        = string
}

variable "resources_bucket" {
  description = "The name of the resources S3 bucket."
  type        = string
}

variable "tags" {
  description = "Key-value map of resource tags."
  type        = map(string)
}

variable "temp_directory" {
  default     = ""
  description = "The temporary S3 path used by Glue Jobs for intermediate results and transient data. If not set, will default to 's3://aws-glue-temporary-<account-id>-<region>'."
  type        = string
}

variable "timeout" {
  default     = 120
  description = "The job timeout in minutes. The default is 120 minutes (2 hours)."
  type        = number
}

variable "worker_type" {
  default     = "G.1X"
  description = "The type of predefined worker that is allocated when a job runs. Accepts a value of 'Standard', 'G.1X', or 'G.2X'. Defaults to 'G.1X'."
  type        = string
  validation {
    condition     = contains(["Standard", "G.1X", "G.2X"], var.worker_type)
    error_message = "The worker_type value must be one of 'Standard', 'G.1X', or 'G.2X'."
  }
}
