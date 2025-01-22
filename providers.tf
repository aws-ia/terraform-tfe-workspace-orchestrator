terraform {
  required_version = ">= 1.3.2"

  required_providers {
    tfe = {
      source  = "hashicorp/tfe"
      version = ">= 0.60.0"
    }
  }
}
