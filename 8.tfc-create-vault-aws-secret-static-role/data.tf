data "terraform_remote_state" "vault_aws_backend" {
  backend = "remote"

  config = {
    organization = "empower-sphere"
    workspaces = {
      name = "tfc-create-vault-aws-secret-dynamic-role"
    }
  }
}

data "terraform_remote_state" "vault_cluster" {
  backend = "remote"

  config = {
    organization = "empower-sphere"
    workspaces = {
      name = "tfc-create-hcp-vault-cluster"
    }
  }
}

data "vault_aws_access_credentials" "master_iamadmin_creds" {
  backend = data.terraform_remote_state.vault_aws_backend.outputs.backend_path
  role    = data.terraform_remote_state.vault_aws_backend.outputs.backend_role
}

data "vault_aws_static_access_credentials" "creds" {
  count = length(var.user_list)
  backend = data.terraform_remote_state.vault_aws_backend.outputs.backend_path
  name    = vault_aws_secret_backend_static_role.static_role[count.index].name
}