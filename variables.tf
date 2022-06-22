variable "workspaces" {
  type = any
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
