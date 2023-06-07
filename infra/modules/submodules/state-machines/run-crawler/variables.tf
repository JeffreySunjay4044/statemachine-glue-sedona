# ---------------------------------------------------------------------------------------------------------------------
# MODULE PARAMETERS
# ---------------------------------------------------------------------------------------------------------------------
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
  description = "The AWS region to deploy to (e.g. us-east-1)"
  type        = string
}

variable "glue_crawler_prefix" {
  description = "The prefix of the Glue crawler."
  type        = string
}

variable "name" {
  default     = "run-crawler"
  description = "The name to use for the state machine"
  type        = string
}

variable "retention_in_days" {
  default     = 14
  description = "The number of days for log group retention"
  type        = number
}

variable "tags" {
  description = "A map of tags to apply to all AWS resources that support it. The key is the tag name and the value is the tag value."
  type        = map(string)
}
