# AWS Glue Job Module
This Terraform module can be used to deploy an AWS Glue Job.

## What is AWS Glue Job?
 * An AWS Glue job encapsulates a script that connects to your source data, processes it, and then writes it out to your data target. Typically, a job runs extract, transform, and load (ETL) scripts.
 * There are three types of jobs in AWS Glue: Spark, Streaming ETL, and Python shell. 
 * Job runs are initiated by glue triggers that can be scheduled or triggered by events.

## Deploy the Terraform code
 * See the [root README](/README.md) for instructions on how to deploy the Terraform code in this repo.
 * See [variables.tf](variables.tf) for all the variables you can set on this module.

## References
 * AWS Doc: https://docs.aws.amazon.com/glue/latest/dg/add-job.html
 * Terraform Doc: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/glue_job
