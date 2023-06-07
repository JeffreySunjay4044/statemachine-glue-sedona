variable "application" {
  description = "The name of the application."
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

variable "connections" {
  default     = []
  description = "The list of connections used for this job."
  type        = list(any)
}

variable "default_arguments" {
  default     = {
    "--additional-python-modules" = "apache-sedona==1.4.0"
    "--pip-install"               = "apache-sedona"
  }
  description = "The map of default arguments for this job."
  type        = map(any)
}

variable "description" {
  default     = ""
  description = "Description of the job."
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

variable "job_type" {
  default     = "glueetl"
  description = "The name of the job command. Defaults to glueetl. Use pythonshell for Python Shell Job Type, max_capacity needs to be set if pythonshell is chosen."
  type        = string

  validation {
    condition     = lower(var.job_type) != "glueetl" || lower(var.job_type) != "pythonshell"
    error_message = "Expected value to be one of [glueetl | pythonshell]."
  }
}

variable "max_capacity" {
  default     = null
  description = "The maximum number of AWS Glue data processing units (DPUs) that can be allocated when this job runs."
  type        = number
}

variable "max_concurrent_runs" {
  default     = 1
  description = "The maximum number of concurrent runs allowed for a job. The default is 1."
  type        = number
}

variable "max_retries" {
  default     = 1
  description = "The maximum number of times to retry this job if it fails."
  type        = number
}

variable "name" {
  description = "The name you assign to this job. It must be unique in your account."
  type        = string
}

variable "non_overridable_arguments" {
  default     = {}
  description = "Non-overridable arguments for this job, specified as name-value pairs."
  type        = map(any)
}

variable "number_of_workers" {
  default     = null
  description = "The number of workers of a defined workerType that are allocated when a job runs."
  type        = number
}

variable "python_version" {
  default     = 3
  description = "The Python version being used to execute a Python shell job. Allowed values are 2 or 3."
  type        = number
}

variable "role_arn" {
  description = "The ARN of the IAM role associated with this job."
  type        = string
}

variable "script_location" {
  description = "Specifies the S3 path to a script that executes a job."
  type        = string
}

variable "security_configuration" {
  default     = ""
  description = "The name of the Security Configuration to be associated with the job."
  type        = string
}

variable "tags" {
  description = "Key-value map of resource tags"
  type        = map(any)
}

variable "timeout" {
  default     = 2880
  description = "The job timeout in minutes. The default is 2880 minutes (48 hours)."
  type        = number
}

variable "worker_type" {
  default     = null
  description = "The type of predefined worker that is allocated when a job runs. Accepts a value of Standard, G.1X, or G.2X."
  type        = string
}
