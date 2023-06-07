# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# DEPLOY AN AWS GLUE CONNECTION
# This template deploys an AWS glue connection.
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# ---------------------------------------------------------------------------------------------------------------------
# Create an AWS Glue Connection
# ---------------------------------------------------------------------------------------------------------------------

locals {
  default_tags = {
    "application" = var.application,
    "env"         = var.aws_environment_name,
    "provider"    = "aws"
  }

  connection_properties = var.connection_type == "NETWORK" ? {} : {
    JDBC_CONNECTION_URL = var.jdbc_connection_url
    PASSWORD            = var.password
    USERNAME            = var.username
  }

  # Merge the default tags with any extra passed in by the user into a single map
  tags = merge(local.default_tags, var.tags)
}

resource "aws_glue_connection" "glue_connection" {
  catalog_id = var.catalog_id

  connection_properties = {
    JDBC_CONNECTION_URL = var.jdbc_connection_url
    PASSWORD            = var.password
    USERNAME            = var.username
  }

  connection_type = var.connection_type
  description     = var.description
  match_criteria  = var.match_criteria
  name            = replace(lower(join("-", compact([var.application, var.aws_environment_name, var.name, var.connection_type]))), " ", "-")

  physical_connection_requirements {
    availability_zone      = var.availability_zone
    security_group_id_list = var.security_group_id_list
    subnet_id              = var.subnet_id
  }
}
