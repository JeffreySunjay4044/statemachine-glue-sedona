# Data Lake - State Machines - Run Chained State Machines

This module deploys a "parent" Step Functions State Machine that will chain together a set of provided "child" State Machines.
It is very similar to 'Run Serial State Machines', but instead of running each child State Machine independently, the output of each State Machine is used as the input for the next.
The first child State Machine receives the input provided to the parent State Machine.
The output of the last child State Machine is the overall output for the parent State Machine.

## Deploy the Terraform code

* See the [root README](/README.md) for instructions on how to deploy the Terraform code in this repo.
* See [variables.tf](variables.tf) for all the variables you can set on this module.

## References

* AWS Step Functions: https://docs.aws.amazon.com/step-functions/index.html
* Invoking State Machines from State Machines: https://docs.aws.amazon.com/step-functions/latest/dg/connect-stepfunctions.html
* State Machine Input and Output Processing: https://docs.aws.amazon.com/step-functions/latest/dg/concepts-input-output-filtering.html
* Terraform String Templates: https://www.terraform.io/language/expressions/strings#string-templates
