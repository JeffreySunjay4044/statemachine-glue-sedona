output "script_location" {
  value = "s3://${aws_s3_bucket_object.glue_shim_script.bucket}/${aws_s3_bucket_object.glue_shim_script.key}"
}