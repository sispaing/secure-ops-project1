output "readonly_rolename" {
  description = "Read Only Role Name"
  value = vault_database_secret_backend_role.readonly.name
}

output "readwrite_rolename" {
  description = "Read Write Role Name"
  value = vault_database_secret_backend_role.readwrite.name
}