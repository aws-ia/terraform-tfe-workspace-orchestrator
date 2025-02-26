#####################################################################################
# Terraform module examples are meant to show an _example_ on how to use a module
# per use-case. The code below should not be copied directly but referenced in order
# to build your own root module that invokes this module
#####################################################################################

module "multi_region_deployment" {
  depends_on = [ tfe_variable_set.test ]
  source = "../.."

  organization = var.organization

  shared_variable_set_named = {
    test = tfe_variable_set.test.id
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

resource "tfe_variable_set" "test" {
  name         = "test"
  organization = var.organization
}