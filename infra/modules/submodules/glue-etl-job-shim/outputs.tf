output "glue_job_arn" {
  value = module.glue_job.glue_job_arn
}

output "glue_job_max_concurrent_runs" {
  value = module.glue_job.glue_job_max_concurrent_runs
}

output "glue_job_name" {
  value = module.glue_job.glue_job_name
}

output "script_location" {
  value = module.shim_script.script_location
}