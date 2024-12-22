output "openid_claims" {
  description = "OpenID Claims for trust relationship"
  value       = vault_jwt_auth_backend_role.tfc_role.bound_claims
}

output "run_role" {
  description = "Name of the vault role for trust relationship"
  value       = vault_jwt_auth_backend_role.tfc_role.role_name
}

output "aws_role" {
  description = "Name of the vault role for AWS trust relationship"
  value       = vault_jwt_auth_backend_role.tfc_aws_secret_role.role_name
}



output "admin_role" {
  description = "Name of the vault role for AWS trust relationship"
  value       = vault_jwt_auth_backend_role.tfc_admin_role.role_name
}