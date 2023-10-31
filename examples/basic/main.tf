#####################################################################################
# Terraform module examples are meant to show an _example_ on how to use a module
# per use-case. The code below should not be copied directly but referenced in order
# to build your own root module that invokes this module
#####################################################################################

module "multi_region_deployment" {
  source = "../.."

  organization = var.organization

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
