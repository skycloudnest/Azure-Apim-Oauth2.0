module "resource_group" {
  source = "git::https://github.com/skycloudnest/Terraform.git//modules/azure/resource_group"

  name     = "rg-${var.project_prefix}-${var.env}-${var.location}"
  location = var.location
  tags = {
    environment = var.env
    ProjectId   = "Apim-Experiments"
  }
}