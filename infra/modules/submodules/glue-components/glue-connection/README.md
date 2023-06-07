# AWS Glue Connections Module
This Terraform module can be used to deploy an AWS Glue Connection.

## What is AWS Glue Connections?
 * An AWS Glue connection is a Data Catalog object that stores connection information for a particular data store.
 * Connections store login credentials, URI strings, virtual private cloud (VPC) information, and more.

## Deploy the Terraform code
 * See the [root README](/README.md) for instructions on how to deploy the Terraform code in this repo.
 * See [variables.tf](variables.tf) for all the variables you can set on this module.

## References
 * AWS Doc: https://docs.aws.amazon.com/glue/latest/dg/populate-add-connection.html
 * Terraform Doc: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/glue_connection
