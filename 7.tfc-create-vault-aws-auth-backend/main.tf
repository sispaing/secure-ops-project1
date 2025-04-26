//-------------------------------------------------
//-Enable AWS Auth Method
//-------------------------------------------------
resource "vault_auth_backend" "main" {
  type = "aws"
  path = var.aws_master_auth

  tune {
    default_lease_ttl = "20m"
    max_lease_ttl      = "60m"
  }
}

//--------------------------------------------------------------------------
//-Assign the AWS IAM user credentials to the AWS auth method configuration.
//---------------------------------------------------------------------------
resource "vault_aws_auth_backend_client" "main" {
  backend    = vault_auth_backend.main.path
  access_key = aws_iam_access_key.vault_auth_accesskey.id
  secret_key = aws_iam_access_key.vault_auth_accesskey.secret
}

//--------------------------------------------------------------------------------------------
//-Configure a Vault Dedicated role to authenticate AWS services with a trusted AWS IAM role.
//--------------------------------------------------------------------------------------------
resource "vault_aws_auth_backend_role" "main" {
  backend                         = vault_auth_backend.main.path
  role                            = var.aws_auth_role
  auth_type                       = var.role_type
  bound_iam_principal_arns        = [aws_iam_role.vault-client.arn]
  token_ttl                       = 600
  token_max_ttl                   = 1200
  token_policies                  = [vault_policy.mysql-policy.name]

  depends_on = [ aws_iam_role.vault-client ]
}

//------------------------------------------------
//-Create Vault Policy for AWS Auth Backend Role
//------------------------------------------------

resource "vault_policy" "mysql-policy" {
  name = var.db_policy

  policy = <<EOT
# Allow tokens to query themselves
path "auth/token/lookup-self" {
  capabilities = ["read"]
}

# Allow tokens to renew themselves
path "auth/token/renew-self" {
    capabilities = ["update"]
}

# Allow tokens to revoke themselves
path "auth/token/revoke-self" {
    capabilities = ["update"]
}

path "db/" {
  capabilities = ["read","list"]
}

path "db/*" {
  capabilities = ["read","list"]
}
EOT
}
