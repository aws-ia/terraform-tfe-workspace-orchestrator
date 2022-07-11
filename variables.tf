variable "workspaces" {
  type = any
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
      <var_name> = {
        value    = <var value>
        category = "env" # valid values: "env" or "terraform", default = "env"
      }
    }
    ```

  Workspace `tag_names` will attempt to combine specific tag_names and from `var.shared_workspace_tag_names`.
EOF
}

variable "shared_variable_set_id" {
  description = "A variable set ID to set to all workspaces. Use if you have a pre-existing variable set."
  type        = string
  default     = null
}

variable "shared_variable_set" {
  description = "A variable set ID to create and set to all workspaces. Use if you want to share variables across all workspaces. To set per-workspace, see `var.workspaces`."
  type        = map(map(string))
  default     = {}
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
    identifier     = string
    oauth_token_id = string
    branch         = optional(string)
  })
}

variable "organization" {
  type = string
}
