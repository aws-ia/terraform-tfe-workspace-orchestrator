<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.2.2 |
| <a name="requirement_tfe"></a> [tfe](#requirement\_tfe) | ~> 0.51 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_tfe"></a> [tfe](#provider\_tfe) | ~> 0.51 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_multi_region_deployment"></a> [multi\_region\_deployment](#module\_multi\_region\_deployment) | ../.. | n/a |

## Resources

| Name | Type |
|------|------|
| [tfe_variable_set.test](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/variable_set) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_organization"></a> [organization](#input\_organization) | n/a | `any` | n/a | yes |
| <a name="input_vcs_repo"></a> [vcs\_repo](#input\_vcs\_repo) | Definition of the VCS repo to attach to every workspace. | <pre>object({<br/>    branch                     = optional(string)<br/>    github_app_installation_id = optional(string)<br/>    identifier                 = string<br/>    ingress_submodules         = optional(bool)<br/>    oauth_token_id             = optional(string)<br/>  })</pre> | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_workspace_attrributes"></a> [workspace\_attrributes](#output\_workspace\_attrributes) | n/a |
| <a name="output_workspace_ids"></a> [workspace\_ids](#output\_workspace\_ids) | n/a |
<!-- END_TF_DOCS -->