locals {
  default_tags = {
    "application" = var.application,
    "env"         = var.aws_environment_name,
    "provider"    = "aws"
  }

  shim_script     = "shim.py"
  shim_script_md5 = filemd5("${path.module}/${local.shim_script}")

  # Merge the default tags with any extra passed in by the user into a single map.
  tags = merge(local.default_tags, var.tags)
}

resource "aws_s3_bucket_object" "glue_shim_script" {
  bucket = var.resources_bucket
  etag   = local.shim_script_md5
  key    = "${var.glue_scripts_path}/${var.name}/${local.shim_script_md5}-${local.shim_script}"
  source = "${path.module}/${local.shim_script}"
  tags   = local.tags
}
