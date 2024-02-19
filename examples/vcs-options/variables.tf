# variable "workspace_name" {
#   default = {
#     value    = "test"
#     category = "terraform"
#   }
# }

variable "vcs_repo" {
  description = "Definition of the VCS repo to attach to every workspace."
  default     = null

  type = object({
    branch                     = optional(string)
    github_app_installation_id = optional(string)
    identifier                 = string
    ingress_submodules         = optional(bool)
    oauth_token_id             = optional(string)
  })
}

variable "organization" {}
# variable "creds_variable_set_name" {}
# variable "shared_variable_set" {}
