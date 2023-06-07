variable "application" {
  description = "The name of the application."
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

variable "data_lake_bucket" {
  description = "The name of the data lake S3 bucket."
  type        = string
}

variable "enable_destination_crawler" {
  default     = false
  description = "Determines whether the destination Glue crawler will be created and enabled to run in the state machine."
  type        = bool
}

variable "glue_crawler_prefix" {
  description = "The prefix of the Glue crawler."
  type        = string
}

variable "glue_job_default_arguments" {
  default     = {}
  description = "A map of default arguments for the optimization Glue Job. These arguments will be passed to every run of the job, and can be overridden in specific run configurations."
  type        = map(string)
}

variable "glue_job_enable_bookmarking" {
  default     = false
  description = "Enable bookmarking (e.g., continuations) for the optimization Glue Job."
  type        = bool
}

variable "glue_job_number_of_workers" {
  default     = 2
  description = "The number of workers that are allocated for the optimization Glue Job."
  type        = number
}

variable "glue_job_python_modules" {
  description = "A list of Python modules to include in the optimization Glue Job. Specific module versions can be specified using standard Pip syntax (e.g., 'allied_world_glue==0.1.2') If no version is provided, the latest release version will be used."
  type        = list(string)
}

variable "glue_job_timeout" {
  default     = 60
  description = "The optimization Glue Job timeout in minutes."
  type        = number
}

variable "glue_job_worker_type" {
  default     = "Standard"
  description = "The type of predefined worker that is allocated when a job runs. Accepts a value of 'Standard', 'G.1X', or 'G.2X'."
  type        = string
  validation {
    condition     = contains(["Standard", "G.1X", "G.2X"], var.glue_job_worker_type)
    error_message = "The worker_type value must be one of 'Standard', 'G.1X', or 'G.2X'."
  }
}

variable "glue_network_connection_name" {
  description = "The name of the network-type Glue Connection for this data lake."
  type        = string
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

variable "processed_glue_database_name" {
  default     = null
  description = "The name of the Glue database that contains tables for processed data.  Must be defined if 'enable_destination_crawler' is true."
  type        = string
}

variable "phase_name" {
  default     = "optimization"
  description = "The unique name of this phase of the Data Lake platform."
  type        = string
}

variable "phase_output_path" {
  default     = "processed"
  description = "The S3 output path where data from this module will land. This should be past tense (e.g., 'processed')."
  type        = string
}

variable "pip_index_url" {
  default     = "https://dbuescrz28.execute-api.us-east-1.amazonaws.com/prod/pypi/allied_world_glue/simple/"
  description = "The URL of a PyPi-compatible package repository, to be used in place of the default public PyPi repository."
  type        = string
}

variable "resources_bucket" {
  description = "The name of the resources S3 bucket."
  type        = string
}

variable "tags" {
  description = "A key-value map of resource tags."
  type        = map(any)
}

variable "temp_bucket" {
  description = "The name of the temporary S3 bucket."
  type        = string
}
