terraform {
  required_version = ">= 1.2.2"
  experiments      = [module_variable_optional_attrs]

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0.0, < 5.0.0"
    }
    # tfe = {
    #   source  = "varset/hashicorp/tfe"
    #   version = ">= 0.0.1"
    # }
  }
}
