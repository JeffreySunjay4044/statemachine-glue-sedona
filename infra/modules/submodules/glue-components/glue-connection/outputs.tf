output "catalog_id" {
  value = aws_glue_connection.glue_connection.catalog_id
}

output "connection_type" {
  value = aws_glue_connection.glue_connection.connection_type
}

output "name" {
  value = aws_glue_connection.glue_connection.name
}

output "vpc_settings" {
  value = aws_glue_connection.glue_connection.physical_connection_requirements
}
