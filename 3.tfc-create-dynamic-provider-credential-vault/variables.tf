variable "jwt_backend_path" {
  type        = string
  default     = "jwt"
  description = "The path at which you'd like to mount the jwt auth backend in Vault"
}

variable "tfc_vault_audience" {
  type        = string
  default     = "vault.workload.identity"
  description = "The audience value to use in run identity tokens"
}

variable "tfc_hostname" {
  type        = string
  default     = "app.terraform.io"
  description = "The hostname of the TFC or TFE instance you'd like to use with Vault"
}

variable "tfc_role_name" {
  type        = string
  default     = "tfc-kv-secret-role"
  description = "This role is to test to create KV Secret with this jwt secret backend with tfc"
}

variable "tfc_organization_name" {
  type        = string
  description = "The name of your Terraform Cloud organization"
  default     = "nick-hellocloud-tf-org"
}

variable "tfc_project_name" {
  type        = string
  description = "The project under which a workspace will be created"
  default = "Secure-Ops-Project1"
}

variable "tfc_workspace_name" {
  type        = string
  default     = "*"
  description = "The name of the workspace that you'd like to create and connect to Vault"
}

variable "tfc_admin_role_name" {
  type        = string
  default     = "tfc-admin-role"
  description = "The name of Role for Admin"
}


variable "tfc_aws_secret_role_name" {
  type        = string
  default     = "tfc-aws-secret-role"
  description = "The name of Role for AWS Secret"
}

variable "tfc_admin_policy" {
  type        = string
  default     = "tfc-admin-policy"
  description = "The name of Admin Policy"
}