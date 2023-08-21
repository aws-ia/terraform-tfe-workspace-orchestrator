terraform {
  required_version = ">= 1.3.2"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">=4.0.0, < 6.0.0"
    }
    tfe = {
      source  = "hashicorp/tfe"
      version = ">= 0.44.0"
    }
  }
}
