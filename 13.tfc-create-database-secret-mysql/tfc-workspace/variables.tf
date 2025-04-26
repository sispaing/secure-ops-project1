
#################################################################################
### TFC WorkSpace Variable
#################################################################################

variable "workspace_name" {
  description = "Workspace Name"
  type = string
  default = "tfc-create-database-secret-mysql"
}

variable "org_name" {
  description = "Organization Name"
  type = string
  default = "empower-sphere"
}

variable "vault_url" {
  description = "The address of the Vault instance runs will access."
  type = string
  default = "https://hcp-vault-cluster-public-vault-f44ef8a4.bbeb9fa5.z1.hashicorp.cloud:8200"
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


