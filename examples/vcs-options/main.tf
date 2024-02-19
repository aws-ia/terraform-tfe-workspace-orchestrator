#####################################################################################
# Terraform module examples are meant to show an _example_ on how to use a module
# per use-case. The code below should not be copied directly but referenced in order
# to build your own root module that invokes this module
#####################################################################################

module "multi_region_deployment" {
  source = "../.."

  organization = var.organization

  vcs_repo = {
    identifier     = "orgname/repo"
    oauth_token_id = "ot-0AuTH_T0kEn_1D"
    branch         = "some_branch" # Can be omitted, the default branch will be used (https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/workspace#branch)
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
    # This workspace will not enable VCS
    disabled_vcs = {
      vcs_repo_enable = false
    }
    # This workspace will enable VCS but not inherit VCS general settings
    custom_vcs = {
      vcs_repo = {
        identifier     = "orgname/other_repo"
        oauth_token_id = "ot-0AuTH_T0kEn_1D"
      }
    }
  }
}
