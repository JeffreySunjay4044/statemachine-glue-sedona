variable "application" {
  description = "The name of the application."
  type        = string
}

variable "availability_zone" {
  default     = "us-east-1a"
  description = "The availability zone of the connection. This field is redundant and implied by subnet_id, but is currently an api requirement."
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

variable "catalog_id" {
  description = "The ID of the Data Catalog in which to create the connection. If none is supplied, the AWS account ID is used by default."
  type        = string
}

variable "connection_type" {
  default     = "JDBC"
  description = "The type of the connection. Supported are: JDBC and NETWORK. Defaults to JBDC."
  type        = string
}

variable "description" {
  default     = "Glue Connection"
  description = "Description of the connection."
  type        = string
}

variable "jdbc_connection_url" {
  default     = ""
  description = "Data store connection URL"
  type        = string
}

variable "match_criteria" {
  default     = []
  description = "A list of criteria that can be used in selecting this connection."
  type        = list(any)
}

variable "name" {
  default = ""
  type    = string
}

variable "password" {
  default     = ""
  description = "Password for the given user name"
  type        = string
}

variable "security_group_id_list" {
  default     = []
  description = "The security group ID list used by the connection."
  type        = list(any)
}

variable "subnet_id" {
  description = "The subnet ID used by the connection."
  type        = string
}

variable "tags" {
  default     = {}
  description = "A map of tags to apply to all AWS resources that support it. The key is the tag name and the value is the tag value."
  type        = map(string)
}

variable "username" {
  default     = ""
  description = "Data store user name"
  type        = string
}
