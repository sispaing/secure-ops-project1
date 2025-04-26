output "information" {
  value = <<EOF

Vault AWS Auth Backend Path: ${vault_auth_backend.main.path}
Vault AWS Auth Role Name: ${vault_aws_auth_backend_role.main.role_id}
AWS IAM User for AWS Auth: ${aws_iam_user.vault_aws_auth.name}
AWS IAM Role Name for AWS Auth :${aws_iam_role.vault-client.name}
AWS IAM Role ARN for AWS Auth :${aws_iam_role.vault-client.arn}
EOF
}