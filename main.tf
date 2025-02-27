locals {
  individual_workspace_vars_map               = { for w, value in var.workspaces : w => value.vars if try(value.vars, {}) != {} }
  individual_workspace_vars                   = flatten([for workspace, variables in local.individual_workspace_vars_map : [for variable in keys(variables) : "${workspace}/${variable}"]])
  individual_workspace_vcs_repo_arguments_map = { for r, value in var.workspaces : r => value.vcs_repo if try(value.vcs_repo, {}) != {} }
  individual_workspace_vsids_map              = { for v, value in var.workspaces : v => value.variable_set_ids if try(value.variable_set_ids, {}) != {} }
  individual_workspace_vsids                  = flatten([for workspace, vsids in local.individual_workspace_vsids_map : [for vsid in vsids : "${workspace}/${vsid}"]])
  # shared_variable_sets_per_workspace = { for w, value in var.workspaces : w => value.vars if try(value.vars, {}) != {} }
}

resource "tfe_workspace" "main" {
  for_each = var.workspaces

  name         = each.key
  organization = var.organization
  project_id   = try(each.value["project_id"], null)

  allow_destroy_plan            = try(each.value["allow_destroy_plan"], null)
  assessments_enabled           = try(each.value["assessments_enabled"], false) # drift detection
  auto_apply                    = try(each.value["auto_apply"], true)
  description                   = try(each.value["description"], null)
  file_triggers_enabled         = try(each.value["file_triggers_enabled"], true)
  global_remote_state           = try(each.value["global_remote_state"], null)
  remote_state_consumer_ids     = try(each.value["remote_state_consumer_ids"], null)
  queue_all_runs                = try(each.value["queue_all_runs"], true)
  source_name                   = try(each.value["source_name"], null)
  source_url                    = try(each.value["source_url"], null)
  speculative_enabled           = try(each.value["speculative_enabled"], true)
  structured_run_output_enabled = try(each.value["structured_run_output_enabled"], true)
  ssh_key_id                    = try(each.value["ssh_key_id"], null)
  terraform_version             = try(each.value["terraform_version"], null)
  trigger_patterns              = try(each.value["trigger_patterns"], null)
  trigger_prefixes              = try(each.value["trigger_prefixes"], null)
  working_directory             = try(each.value["working_directory"], null)
  tag_names                     = concat(var.shared_workspace_tag_names, try(each.value["tag_names"], []))

  dynamic "vcs_repo" {
    for_each = ((try(var.vcs_repo, null) != null) && try(each.value.vcs_repo_enable, true)) ? [true] : []
    content {
      branch                     = (try(each.value.vcs_repo_enable, false) && can(each.value.vcs_repo != null)) ? try(local.individual_workspace_vcs_repo_arguments_map[each.key].branch, null) : try(var.vcs_repo.branch, null)
      github_app_installation_id = (try(each.value.vcs_repo_enable, false) && can(each.value.vcs_repo != null)) ? try(local.individual_workspace_vcs_repo_arguments_map[each.key].github_app_installation_id, null) : try(var.vcs_repo.github_app_installation_id, null)
      identifier                 = (try(each.value.vcs_repo_enable, false) && can(each.value.vcs_repo != null)) ? try(local.individual_workspace_vcs_repo_arguments_map[each.key].identifier, null) : var.vcs_repo.identifier
      ingress_submodules         = (try(each.value.vcs_repo_enable, false) && can(each.value.vcs_repo != null)) ? try(local.individual_workspace_vcs_repo_arguments_map[each.key].ingress_submodules, null) : try(var.vcs_repo.ingress_submodules, null)
      oauth_token_id             = (try(each.value.vcs_repo_enable, false) && can(each.value.vcs_repo != null)) ? try(local.individual_workspace_vcs_repo_arguments_map[each.key].oauth_token_id, null) : try(var.vcs_repo.oauth_token_id, null)
    }
  }
}

# attach pre-existing variable set to workspaces
resource "tfe_workspace_variable_set" "shared_preexisting_variable_set_ids" {
  for_each = toset(length(var.shared_variable_set_ids) == 0 ?
    [] :
    flatten([for w, value in var.workspaces : [for vsid in var.shared_variable_set_ids : "${w}/${vsid}"]])
  )

  variable_set_id = split("/", each.key)[1]
  workspace_id    = tfe_workspace.main[split("/", each.key)[0]].id
}

resource "tfe_workspace_variable_set" "shared_named_variable_sets" {
  for_each = toset(length(var.shared_variable_sets) == 0 ?
    [] :
    flatten([for w, value in var.workspaces : [for vs in var.shared_variable_sets : "${w}/${vs}"]])
  )

  variable_set_id = data.tfe_variable_set.shared_variable_sets[split("/", each.key)[1]].id
  workspace_id    = tfe_workspace.main[split("/", each.key)[0]].id
}

data "tfe_variable_set" "shared_variable_sets" {
  for_each = toset(var.shared_variable_sets)

  name         = each.key
  organization = var.organization
}

resource "tfe_variable" "workspace" {
  for_each = toset(local.individual_workspace_vars)

  workspace_id = tfe_workspace.main[split("/", each.key)[0]].id

  category    = try(var.workspaces[split("/", each.key)[0]].vars[split("/", each.key)[1]].category, "env")
  key         = split("/", each.key)[1]
  value       = var.workspaces[split("/", each.key)[0]].vars[split("/", each.key)[1]].value
  description = try(var.workspaces[split("/", each.key)[0]].vars[split("/", each.key)[1]].description, null)
}

resource "tfe_workspace_settings" "this" {
  for_each = var.workspaces

  workspace_id   = tfe_workspace.main[each.key].id
  execution_mode = can(each.value["agent_pool_id"] != null) ? "agent" : try(each.value["execution_mode"], "remote")
  agent_pool_id  = can(each.value["agent_pool_id"] != null) ? each.value["agent_pool_id"] : null
}

resource "tfe_workspace_variable_set" "this" {
  for_each = toset(local.individual_workspace_vsids)

  workspace_id    = tfe_workspace.main[split("/", each.key)[0]].id
  variable_set_id = split("/", each.key)[1]
}

# # create variable set for workspaces that specify their own variables
# resource "tfe_variable_set" "per_workspace" {
#   count = var.shared_variable_set == {} ? 0 : 1

#   name          = var.shared_variable_set
#   description   = each.key
#   organization  = var.organization
#   workspace_ids = local.workspace_ids
# }

# create variables specified by each workspace in var.workspaces.*.vars

# create variable set for workspaces that specify their own variables
# resource "tfe_variable_set" "shared_to_all_workspaces" {
#   count = var.shared_variable_set == {} ? 0 : 1

#   name          = "shared-to-all-workspaces"
#   description   = "shared-to-all-workspaces"
#   organization  = var.organization
#   workspace_ids = local.workspace_ids
# }

# resource "tfe_variable" "shared_to_all_workspaces" {
#   for_each = var.shared_variable_set

#   variable_set_id = tfe_variable_set.shared_to_all_workspaces[0].id
#   key             = each.key
#   value           = each.value.value
#   category        = try(each.value.category, "env")
# }
