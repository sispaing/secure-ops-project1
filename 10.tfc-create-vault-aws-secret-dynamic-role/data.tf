data "terraform_remote_state" "vault_admin" {
  backend = "remote"

  config = {
    organization = "empower-sphere"
    workspaces = {
      name = "tfc-create-vault-admin-iam-aws"
    }
  }
}


