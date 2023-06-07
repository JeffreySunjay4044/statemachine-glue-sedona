terraform {



  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.25"
    }
    template = {
      source  = "hashicorp/template"
      version = ">= 2.2"
    }
  }

  required_version = ">= 1.0.0"
}
