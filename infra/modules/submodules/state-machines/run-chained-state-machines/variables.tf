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

variable "name" {
  default     = "chained-state-machines"
  description = "The name to use for the state machine"
  type        = string
}

variable "retention_in_days" {
  default     = 30
  description = "The number of days to retain state machine log messages."
  type        = number
}

variable "state_machine_arns" {
  description = "A list of Step Functions State Machine ARNs, which will be executed in the order they appear in the list."
  type        = list(string)
  validation {
    condition     = length(var.state_machine_arns) > 0
    error_message = "At least one State Machine ARN must be provided."
  }
}

variable "tags" {
  description = "A map of tags to apply to all AWS resources that support it. The key is the tag name and the value is the tag value."
  type        = map(string)
}
