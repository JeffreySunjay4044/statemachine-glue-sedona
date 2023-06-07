output "glue_crawler_dynamodb_arn" {
  value = join(",", aws_glue_crawler.glue_crawler_dynamodb.*.arn)
}

output "glue_crawler_dynamodb_id" {
  value = join(",", aws_glue_crawler.glue_crawler_dynamodb.*.id)
}

output "glue_crawler_dynamodb_name" {
  value = join(",", aws_glue_crawler.glue_crawler_dynamodb.*.name)
}

output "glue_crawler_jdbc_arn" {
  value = join(",", aws_glue_crawler.glue_crawler_jdbc.*.arn)
}

output "glue_crawler_jdbc_id" {
  value = join(",", aws_glue_crawler.glue_crawler_jdbc.*.id)
}

output "glue_crawler_jdbc_name" {
  value = join(",", aws_glue_crawler.glue_crawler_jdbc.*.name)
}

output "glue_crawler_s3_arn" {
  value = join(",", aws_glue_crawler.glue_crawler_s3.*.arn)
}

output "glue_crawler_s3_id" {
  value = join(",", aws_glue_crawler.glue_crawler_s3.*.id)
}

output "glue_crawler_s3_name" {
  value = join(",", aws_glue_crawler.glue_crawler_s3.*.name)
}
