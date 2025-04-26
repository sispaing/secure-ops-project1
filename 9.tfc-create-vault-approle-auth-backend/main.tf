resource "vault_auth_backend" "tfc-approle" {
  description = "Vault TFC AppRole Auth Method"
  type = var.auth_backend_type
  path = var.auth_backend_path
}

resource "vault_policy" "db_secret_backend_policy" {
  name = var.db_secret_policy
  policy = <<EOT
path "db/" {
  capabilities = ["read","list"]
}

path "db/*" {
  capabilities = ["read","list"]
}

path "auth/token/create" 
{
  capabilities = ["update"]
}
EOT
}

resource "vault_policy" "admin_policy" {
  name = var.admin_policy
  policy = <<EOT
path "auth/*"
{
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}

# Create, update, and delete auth methods
path "sys/auth/*"
{
  capabilities = ["create", "update", "delete", "sudo"]
}

# List auth methods
path "sys/auth"
{
  capabilities = ["read"]
}

# Enable and manage the key/value secrets engine at `secret/` path

# List, create, update, and delete key/value secrets
path "secret/*"
{
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}

# Manage secrets engines
path "sys/mounts/*"
{
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}

# List existing secrets engines.
path "sys/mounts"
{
  capabilities = ["read"]
}
EOT
}

resource "vault_approle_auth_backend_role" "db_approle_role" {
  backend = vault_auth_backend.tfc-approle.path
  role_name = var.db_approle_role_name
  token_policies = [vault_policy.db_secret_backend_policy.name]
  token_ttl = 600
  token_max_ttl = 1800
}

resource "vault_approle_auth_backend_role_secret_id" "db_approle_role_sid" {
  backend = vault_auth_backend.tfc-approle.path
  role_name = vault_approle_auth_backend_role.db_approle_role.role_name
}

resource "vault_approle_auth_backend_role" "admin_approle_role" {
  backend = vault_auth_backend.tfc-approle.path
  role_name = var.admin_approle_role_name
  token_policies = [vault_policy.admin_policy.name]
  token_ttl = 1200
  token_max_ttl = 3600
}

resource "vault_approle_auth_backend_role_secret_id" "admin_approle_role_sid" {
  backend = vault_auth_backend.tfc-approle.path
  role_name = vault_approle_auth_backend_role.admin_approle_role.role_name
}
