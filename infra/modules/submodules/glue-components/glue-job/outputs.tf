output "glue_job_arn" {
  value = aws_glue_job.glue_job.arn
}

output "glue_job_id" {
  value = aws_glue_job.glue_job.id
}

output "glue_job_max_concurrent_runs" {
  value = aws_glue_job.glue_job.execution_property[0].max_concurrent_runs
}

output "glue_job_name" {
  value = aws_glue_job.glue_job.name
}