# Data Lake Optimization

This module encapsulates the infrastructure and other resources necessary to deploy the "Simple S3" optimization phase of an Allied World Data Lake.

It uses an instance of the `run-parallel-jobs` State Machine to execute a single set of parallel Glue runs, each using a specific Job class from a supplied Python module.
