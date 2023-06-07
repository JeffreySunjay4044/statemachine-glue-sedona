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
  description = "The AWS region to deploy to (e.g. us-east-1)."
  type        = string
}

variable "destination_glue_crawler_name" {
  default     = null
  description = "The name of the destination Glue Crawler. Must be set if 'run_destination_crawler' is true."
  type        = string
}

variable "destination_s3_uri_prefix" {
  description = "The S3 URI prefix used for the output of the Glue Job. Must be of the form 's3://<bucket-name>/<path>'."
  type        = string
}

variable "get_tables_lambda_arn" {
  description = "The ARN of the 'GetTables' Lambda Function."
  type        = string
}

variable "glue_job_name" {
  description = "The name of the Glue Job which will be executed via the State Machine."
  type        = string
}

variable "glue_job_run_waiter_seconds" {
  default     = 15
  description = "The number of seconds to wait between each concurrent Glue Job run."
  type        = number
}

variable "glue_job_retry_interval_seconds" {
  default     = 30
  description = "The number of seconds to wait between Glue Job retries."
  type        = number
}

variable "max_glue_concurrency" {
  default     = 15
  description = "The maximum number of Glue Jobs that can be run concurrently."
  type        = number
}

variable "name" {
  default     = "catalog-to-s3"
  description = "The name to use for the state machine"
  type        = string
}

variable "reserve_glue_concurrency" {
  default     = 3
  description = "The number of concurrent Glue Job executions *not* used by the state machine (from 'max_glue_concurrency'), to account for eventual consistency in job tracking as well as one-off executions."
  type        = number
}

variable "retention_in_days" {
  default     = 30
  description = "The number of days to retain state machine log messages."
  type        = number
}

variable "run_crawler_state_machine_arn" {
  default     = null
  description = "The ARN of the 'RunCrawler' State Machine. Must be set if 'run_source_crawler' or 'run_destination_crawler' is true."
  type        = string
}

variable "run_destination_crawler" {
  default     = false
  description = "Whether or not to run the destination Glue Crawler. If set to true, 'run_crawler_state_machine_arn' and 'destination_glue_crawler_name' must also be provided."
  type        = bool
}

variable "run_source_crawler" {
  default     = false
  description = "Whether or not to run the source Glue Crawler. If set to true, 'run_crawler_state_machine_arn' and 'source_glue_crawler_name' must also be provided."
  type        = bool
}

variable "source_glue_crawler_name" {
  default     = null
  description = "The name of the source Glue Crawler. Must be set if 'run_source_crawler' is true."
  type        = string
}

variable "source_glue_database_name" {
  description = "The name of the source Glue Database."
  type        = string
}

variable "tags" {
  description = "A map of tags to apply to all AWS resources that support it. The key is the tag name and the value is the tag value."
  type        = map(string)
}
