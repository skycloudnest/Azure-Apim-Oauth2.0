locals {
  logic_app_name = "logic-${var.project_prefix}-request-${var.env}"
}

module "logic_app" {
  source = "git::https://github.com/skycloudnest/Terraform.git//modules/azure/logic_app"

  module_dir                 = "../../logic_apps/request_logic_app"
  location                   = var.location
  logic_app_name             = local.logic_app_name
  resource_group_name        = module.resource_group.name
  enabled                    = true

  arm_parameters = {
    workflow_name                       = local.logic_app_name
    location                            = var.location
  }
  templates_files = {
    bicep_path = "./workflow.bicep"
  }
}

module "http_trigger_logic_app" {
  source                = "git::https://github.com/skycloudnest/Terraform.git//modules/azure/logic_app_trigger_http_request_data"

  logic_app_id    = module.logic_app.id
  trigger_name    = "request"

  depends_on = [
    module.logic_app
  ]
}
