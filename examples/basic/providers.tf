terraform {
  required_version = ">= 1.2.2"
  experiments      = [module_variable_optional_attrs]

  required_providers {
    tfe = {
      source  = "varset/hashicorp/tfe"
      version = ">= 0.0.1"
    }
  }
}
