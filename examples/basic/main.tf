#####################################################################################
# Terraform module examples are meant to show an _example_ on how to use a module
# per use-case. The code below should not be copied directly but referenced in order
# to build your own root module that invokes this module
#####################################################################################

data "tfe_variable_set" "creds" {
  name         = var.creds_variable_set_name
  organization = var.organization
}

module "multi_region_deployment" {
  source = "../.."

  shared_variable_set_id = data.tfe_variable_set.creds.id
  organization           = var.organization
  vcs_repo               = var.vcs_repo
  shared_variable_set = {
    test  = { value = 123 } # implicit category = "env"
    test2 = { value = 123, category = "terraform" }
  }

  workspaces = {
    eastcoast = {
      vars = {
        AWS_REGION = {
          value = "us-east-1"
        }
      }
    }
    westcoast = {}
  }
}
