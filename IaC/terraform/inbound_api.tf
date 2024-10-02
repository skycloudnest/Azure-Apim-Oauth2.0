locals {
  api_name = "api-${var.project_prefix}-request-incoming-${var.env}"
}


module "inbound_api_named_values" {
  source = "git::https://github.com/skycloudnest/Terraform.git//modules/azure/api_management_named_values"

  api_management_name = module.azure_api_management.name
  resource_group_name = module.resource_group.name

  named_values = [
    {
      name                = "sample-logic-app-url"
      value               = split("/triggers", module.http_trigger_logic_app.trigger_endpoint)[0] // get only URL of workflow
    },
    {
      name                = "sample-logic-app-sas"
      value               = split("&sig=", module.http_trigger_logic_app.trigger_endpoint)[1] // get only signature
      encrypt             = true
    }
  ]
  
  depends_on = [
    module.http_trigger_logic_app
  ]
}


module "azure_api_management_sample_api" {
  source = "git::https://github.com/skycloudnest/Terraform.git//modules/azure/api_management_api"

  resource_group_name  = module.resource_group.name
  api_management_name  = module.azure_api_management.name
  developer_portal_url = module.azure_api_management.developer_portal_url
  authorization_tenant = var.authorization_tenant
  api_settings = {
    name                  = local.api_name
    service_url           = ""
    revision              = "1"
    basepath              = "logic_app_1"
    subscription_required = false
    openapi_file_path     = "../../apis/sample_api/sample_api.yaml"
  }
  application_name = "app-${var.project_prefix}-sample-${var.env}"
  backend_type     = "public"
  aad_settings = {
    openid_url = "https://login.microsoftonline.com/${var.authorization_tenant}/v2.0/.well-known/openid-configuration"
    issuer     = "https://login.microsoftonline.com/${var.authorization_tenant}/v2.0"
  }
}

module "inbound_api_operation" {
  source = "git::https://github.com/skycloudnest/Terraform.git//modules/azure/api_management_api_operation"

  operation_id              = "sample_call"
  description               = "The endpoint is a sample endpoint with logic app as a backend"
  http_method               = "POST"
  url_template              = "/sample_call"
  operation_display_name    = "Sample_Call"
  api_name                  = local.api_name
  resource_group_name       = module.resource_group.name
  api_management_name       = module.azure_api_management.name

  custom_xml_policy_prepend = <<XML
    <set-header name="Authorization" exists-action="delete" />
    <set-backend-service id="apim-generated-policy" base-url="{{sample-logic-app-url}}" />
    <rewrite-uri template="/triggers/request/paths/invoke?api-version=2016-10-01&amp;sp=%2Ftriggers%2Frequest%2Frun&amp;sv=1.0&amp;sig={{sample-logic-app-sas}}" />
XML

  depends_on = [
    module.inbound_api_named_values,
    module.azure_api_management_sample_api
  ]
}
