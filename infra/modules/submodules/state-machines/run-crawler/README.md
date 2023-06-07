# Run Crawler State Machine Module

This Terraform Module can be used to deploy an [AWS Step Functions](https://aws.amazon.com/step-functions/) State Machine that runs a crawler.


## How do you use this module?

* See the [root README](/README.md) for instructions on using Terraform modules in this repo.
* See [variables.tf](variables.tf) for all the variables you can set on this module.

## What is AWS Step Functions?

AWS Step Functions is a serverless function orchestrator that makes it easy to sequence AWS Lambda functions and multiple AWS services into business-critical applications. Through its visual interface, you can create and run a series of checkpointed and event-driven workflows that maintain the application state. The output of one step acts as an input to the next. Each step in your application executes in order, as defined by your business logic.

Orchestrating a series of individual serverless applications, managing retries, and debugging failures can be challenging. As your distributed applications become more complex, the complexity of managing them also grows. With its built-in operational controls, Step Functions manages sequencing, error handling, retry logic, and state, removing a significant operational burden from your team.
