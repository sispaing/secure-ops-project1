
#################################################################################
### TFC WorkSpace Variable
#################################################################################
variable "workspace_name" {
  description = "Workspace Name"
  type = string
  default = "tfc-create-vault-aws-auth-backend"
}

variable "org_name" {
  description = "Organization Name"
  type = string
  default = "empower-sphere"
}

variable "vault_url" {
  description = "The address of the Vault instance runs will access."
  type = string
  default = "https://hcp-vault-cluster-public-vault-b834ca95.cac1a9be.z1.hashicorp.cloud:8200"
}

variable "run_role" {
  description = "TFC_VAULT_RUN_ROLE"
  type = string
  default = "tfc-admin-role"
}

variable "vault_namespace" {
  description = "TFC_VAULT_NAMESPACE"
  type = string
  default = "admin"
}

variable "aws_mount_path" {
  description = "TFC_VAULT_BACKED_AWS_MOUNT_PATH"
  type = string
  default = "aws-master-account"
}

variable "aws_auth_type" {
  description = "TFC_VAULT_BACKED_AWS_AUTH_TYPE"
  type = string
  default = "iam_user"
}

variable "aws_secret_role" {
  description = "TFC_VAULT_BACKED_AWS_RUN_VAULT_ROLE"
  type = string
  default = "master-iamadmin-role"
}

variable "aws_region" {
  description = "AWS_REGION"
  type = string
  default = "ap-southeast-1"
}