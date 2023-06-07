# Glue ETL Job Shim Module

This Terraform module can be used to deploy an AWS Glue ETL Job using a "shim" script that dynamically resolves the job's implementation at runtime.
For details on the "shim" script, see the [`glue-shim-script` module](../glue-shim-script).

Python modules are loaded via a PyPy-compatible package repository, configured via the `pip_index_url` and `additional_python_modules` variables, or overridden at run time via the `--python-modules-installer-option` and `--additional-python-modules` Glue arguments.

## Deploy the Terraform code
 * See the [root README](/README.md) for instructions on how to deploy the Terraform code in this repo.
 * See [variables.tf](variables.tf) for all the variables you can set on this module.

## References
 * AWS Glue Job: https://docs.aws.amazon.com/glue/latest/dg/add-job.html
 * AWS Glue Python Libraries: https://docs.aws.amazon.com/glue/latest/dg/aws-glue-programming-python-libraries.html
 * Terraform Doc: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/glue_job
