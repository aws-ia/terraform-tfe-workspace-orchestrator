locals {
  individual_workspace_vars_map = { for w, value in var.workspaces : w => value.vars if try(value.vars, {}) != {} }
  individual_workspace_vars     = flatten([for workspace, tags in local.individual_workspace_vars_map : [for tag in keys(tags) : "${workspace}/${tag}"]])
  workspace_ids                 = [for workspace in tfe_workspace.main : workspace.id]
}

resource "tfe_workspace" "main" {
  for_each = var.workspaces

  name         = each.key
  organization = var.organization

  allow_destroy_plan            = try(each.value["allow_destroy_plan"], null)
  auto_apply                    = try(each.value["auto_apply"], true)
  description                   = try(each.value["description"], null)
  execution_mode                = try(each.value["execution_mode"], "remote")
  file_triggers_enabled         = try(each.value["file_triggers_enabled"], true)
  global_remote_state           = try(each.value["global_remote_state"], null)
  remote_state_consumer_ids     = try(each.value["remote_state_consumer_ids"], null)
  queue_all_runs                = try(each.value["queue_all_runs"], true)
  speculative_enabled           = try(each.value["speculative_enabled"], true)
  structured_run_output_enabled = try(each.value["structured_run_output_enabled"], true)
  ssh_key_id                    = try(each.value["ssh_key_id"], null)
  terraform_version             = try(each.value["terraform_version"], null)
  trigger_prefixes              = try(each.value["trigger_prefixes"], null)
  working_directory             = try(each.value["working_directory"], null)
  tag_names                     = concat(var.shared_workspace_tag_names, try(each.value["tag_names"], []))

  dynamic "vcs_repo" {
    for_each = var.vcs_repo == null ? [] : ["true"]

    content {
      identifier     = var.vcs_repo["identifier"]
      oauth_token_id = var.vcs_repo["oauth_token_id"]
      branch         = try(var.vcs_repo["branch"], "main")
    }
  }
}

# attach pre-existing variable set to workspaces
resource "tfe_variable_set_workspace_attachment" "shared_preexisting_variable_set_ids" {
  for_each = var.shared_variable_set_id == null ? {} : tfe_workspace.main

  variable_set_id = var.shared_variable_set_id
  workspace_id    = each.value.id
}

# create variable set for workspaces that specify their own variables
resource "tfe_variable_set" "per_workspace" {
  for_each = local.individual_workspace_vars_map

  name          = each.key
  description   = each.key
  organization  = var.organization
  workspace_ids = local.workspace_ids
}

# create variables specified by each workspace in var.workspaces.*.vars
resource "tfe_variable" "per_workspace" {
  for_each = toset(local.individual_workspace_vars)

  variable_set_id = tfe_variable_set.per_workspace[split("/", each.key)[0]].id

  category = try(var.workspaces[split("/", each.key)[0]].vars[split("/", each.key)[1]].category, "env")
  key      = split("/", each.key)[1]
  value    = var.workspaces[split("/", each.key)[0]].vars[split("/", each.key)[1]].value
}

# create variable set for workspaces that specify their own variables
resource "tfe_variable_set" "shared_to_all_workspaces" {
  count = var.shared_variable_set == {} ? 0 : 1

  name          = "shared-to-all-workspaces"
  description   = "shared-to-all-workspaces"
  organization  = var.organization
  workspace_ids = local.workspace_ids
}

resource "tfe_variable" "shared_to_all_workspaces" {
  for_each = var.shared_variable_set

  variable_set_id = tfe_variable_set.shared_to_all_workspaces[0].id
  key             = each.key
  value           = each.value.value
  category        = try(each.value.category, "env")
}
