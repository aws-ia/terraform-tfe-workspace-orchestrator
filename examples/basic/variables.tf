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
    identifier     = string
    oauth_token_id = string
    branch         = optional(string)
  })
}

variable "organization" {}
# variable "creds_variable_set_name" {}
# variable "shared_variable_set" {}
