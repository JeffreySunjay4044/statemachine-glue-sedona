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

variable "classifiers" {
  default     = []
  description = "A list of Glue Classifiers to use with the crawler (S3 only)."
  type        = list(string)
}

variable "configuration" {
  default     = null
  description = "JSON object of configuration information. This variable is overridden by configuration_string (e.g., if a key needs to be omitted)."
  type = object({
    CrawlerOutput = optional(object({
      Partitions = optional(object({
        AddOrUpdateBehavior = optional(string)
      }))
      Tables = optional(object({
        AddOrUpdateBehavior = optional(string)
      }))
    }))
    Grouping = optional(object({
      TableGroupingPolicy     = optional(string)
      TableLevelConfiguration = optional(number)
    }))
    Version = number
  })
}

variable "configuration_string" {
  default     = ""
  description = "JSON string of configuration information. This variable overrides configuration."
}

variable "database_name" {
  description = "Glue database where results are written."
  type        = string
}

variable "delete_behavior" {
  default     = "DEPRECATE_IN_DATABASE"
  description = "The deletion behavior when the crawler finds a deleted object. Valid values: LOG, DELETE_FROM_DATABASE, or DEPRECATE_IN_DATABASE. Defaults to DEPRECATE_IN_DATABASE."
  type        = string
}

variable "description" {
  default     = ""
  description = "Description of the crawler."
  type        = string
}

variable "dynamodb_targets" {
  default     = [{}]
  description = "List of nested Amazon DynamoDB target arguments."
  type        = list(map(string))
}

variable "jdbc_include_path" {
  default     = ""
  description = "Path to find tables in JDBC source database. This variable overrides jdbc_targets."
}

variable "jdbc_targets" {
  default     = [{}]
  description = "List of nested JBDC target arguments. This variable is overridden by jdbc_include_path."
  type        = list(map(string))
}

variable "name" {
  description = "This variable will be used with application name as name of the crawler."
  type        = string
}

variable "role" {
  description = "The IAM role friendly name (including path without leading slash), or ARN of an IAM role, used by the crawler to access other resources."
  type        = string
}

variable "s3_targets" {
  default     = [{}]
  description = "List of nested Amazon S3 target arguments."
  type        = list(map(string))
}

variable "schedule" {
  default     = null
  description = "A cron expression used to specify the schedule. For more information, see Time-Based Schedules for Jobs and Crawlers. For example, to run something every day at 12:15 UTC, you would specify: cron(15 12 * * ? *)."
  type        = string
}

variable "table_prefix" {
  default     = ""
  description = "The table prefix used for catalog tables that are created."
  type        = string
}

variable "tags" {
  description = "A map of tags to apply to all AWS resources that support it. The key is the tag name and the value is the tag value."
  type        = map(string)
}

variable "target" {
  description = "Crawler target type. Value must be one of DynamoDB, S3 or JDBC."
  type        = string

  validation {
    condition     = var.target != "DynamoDB" || var.target != "S3" || var.target != "JDBC"
    error_message = "Expected value to be one of [DynamoDB | S3 | JDBC]."
  }
}

variable "target_connection_name" {
  default     = ""
  description = "The name of the connection to use to connect to the JDBC target."
  type        = string
}

variable "target_exclusions" {
  default     = ""
  description = "A list of glob patterns used to exclude from the crawl. (e.g. table_1,table_2,table_3)"
  type        = string
}

variable "update_behavior" {
  default     = "UPDATE_IN_DATABASE"
  description = "The update behavior when the crawler finds a changed schema. Valid values: LOG or UPDATE_IN_DATABASE. Defaults to UPDATE_IN_DATABASE."
  type        = string
}
