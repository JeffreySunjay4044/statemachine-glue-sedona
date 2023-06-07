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

variable "glue_scripts_path" {
  default     = "glue-scripts"
  description = "The path (in the resources S3 bucket) where Glue scripts are stored."
  type        = string
}

variable "name" {
  description = "The name assigned to the Glue job. It must be unique in your application."
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
