variable "workspaces" {
  type        = any
  description = <<-EOF
  Nested map of workspaces to create and the associated arguments they can accept:

  Example:
    ```
    workspaces = {
      eastcoast = {
        vars = {
          AWS_REGION = {
            value = "us-east-1"
          }
        }
      }
      westcoast = {...}
    }
    ```

  Arguments accepted within workspace definition:

  - All arguments from [tfe_workspace](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/workspace#argument-reference). Defaults set as documented in July 2022 (v0.33.0).
  - `vars` = A nested map of variables, their value and category

    ```
    vars = {
      myvar_name = {
        value    = "my var value"
        category = "env" # valid values: "env" or "terraform", default = "env"
      }
    }
    ```

  Workspace `tag_names` will attempt to combine specific tag_names and from `var.shared_workspace_tag_names`.
EOF
}

variable "shared_variable_set_ids" {
  description = "A variable set ID to set to all workspaces. Use if you have a pre-existing variable set."
  type        = list(string)
  default     = []
}

variable "shared_variable_sets" {
  description = "A list of variable sets to apply to each workspace. These must be pre-existing or the module must explicitly depend on them."
  type        = list(string)
  default     = []
}

variable "shared_workspace_tag_names" {
  description = "Tag names to set for all workspaces. To set per-workspace, see `var.workspaces`."
  type        = list(any)
  nullable    = false
  default     = []
}

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

variable "organization" {
  description = "TFC Organization"
  type        = string
}
