# AWS Glue Crawler Module

This Terraform module can be used to deploy an AWS Glue Crawler.

## What is AWS Glue Crawler?
 * A program that connects to a data store (source or target), progresses through a prioritized list of classifiers to determine the schema for your data, and then creates metadata tables in the AWS Glue Data Catalog.
 * It can be used to populate the AWS Glue Data Catalog with tables. This is the primary method used by most AWS Glue users.

## Deploy the Terraform code
 * See the [root README](/README.md) for instructions on how to deploy the Terraform code in this repo.
 * See [variables.tf](variables.tf) for all the variables you can set on this module.

## References
 * AWS Doc: https://docs.aws.amazon.com/glue/latest/dg/add-crawler.html
 * Terraform Doc: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/glue_crawler
