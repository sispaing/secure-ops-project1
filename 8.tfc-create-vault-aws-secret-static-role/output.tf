output "static_users_name" {
  description = "Static User Name"
  value = resource.aws_iam_user.vault_static_user[*].name
}

output "static_users_id" {
  description = "Static User ID"
  value = resource.aws_iam_user.vault_static_user[*].id
}

output "static_users_arn" {
  description = "Static User ARN"
  value = resource.aws_iam_user.vault_static_user[*].arn
}

output "creds_vault_static_user_accesskey" {
  description = "Credential of Static Users Access Key"
  value = data.vault_aws_static_access_credentials.creds[*].access_key
  sensitive = true
}

output "creds_vault_static_user_secret_accesskey" {
  description = "Credential of Static Users Secret Key"
  value = data.vault_aws_static_access_credentials.creds[*].secret_key
  sensitive = true
}