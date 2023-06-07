# Glue Shim Script Module

This Terraform module can be used to deploy a "shim" script to S3 that dynamically resolves a Glue job's implementation at runtime.
Note that this module is *only* the script.
See the [`glue-etl-job-shim` module](../glue-etl-job-shim) for a complete Glue Job that uses this script.

The "shim" script relies only on the availability of a class that has a "run" method.
This is configured using the `job_entry_point` variable, and can be overridden at run time by using the `--job_entry_point` Glue argument.
Job classes are provided via Python modules (e.g., "allied_world_glue").

### Testing the Shim Script

A `test.py` file contains tests for the shim script.
Those tests can be executed by running the following Python command, using Python version 3.5 or higher:

```shell
$ python test.py 
......
----------------------------------------------------------------------
Ran 6 tests in 0.001s

OK
```

## Deploy the Terraform code
 * See the [root README](/README.md) for instructions on how to deploy the Terraform code in this repo.
 * See [variables.tf](variables.tf) for all the variables you can set on this module.

## References
 * AWS Glue Job: https://docs.aws.amazon.com/glue/latest/dg/add-job.html
 * Terraform Doc: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/glue_job
