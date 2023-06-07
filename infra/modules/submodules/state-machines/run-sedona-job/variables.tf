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

variable "tags" {
  description = "A map of tags to apply to all AWS resources that support it. The key is the tag name and the value is the tag value."
  type        = map(string)
}
