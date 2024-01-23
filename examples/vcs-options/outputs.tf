output "workspace_ids" {
  value = [for ws in module.multi_region_deployment.workspaces_attributes :
    ws.id
  ]
}

output "workspace_attrributes" {
  value = module.multi_region_deployment.workspaces_attributes
}
