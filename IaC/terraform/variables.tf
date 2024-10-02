variable "env" {
  description = "Name of environment - will be part of resources names"
}

variable "location" {
  default     = "westeurope"
  description = "azure region where resources will be created"
}

variable "project_prefix" {
  default     = "apim-exp"
  description = "Project prefix"
}

variable "authorization_tenant" {
  description = "The local path to a workspace directory"
  type        = string
}

variable "workspace_directory" {
  description = "The local path to a workspace directory"
  type        = string
}