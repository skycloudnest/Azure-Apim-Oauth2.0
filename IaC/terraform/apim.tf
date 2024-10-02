module "azure_api_management" {
  source = "git::https://github.com/skycloudnest/Terraform.git//modules/azure/api_management"

  location             = var.location
  resource_group_name  = module.resource_group.name
  name                 = "apim-${var.project_prefix}-${var.env}-${var.location}"
  publisher_name       = "SkyCloudNest"
  publisher_email      = "rozek1szymon@gmail.com"
  allowed_tenants      = [var.authorization_tenant]
}