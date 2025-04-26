data "terraform_remote_state" "approle" {
  backend = "remote"

  config = {
    organization = "empower-sphere"
    workspaces = {
      name = "tfc-create-vault-approle-auth-backend"
    }
  }
}