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
# Manage system backend
path "db/*"
{
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}

# List existing db
path "db/*"
{
  capabilities = ["read"]
}
path "aws-master-account/"
{
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}
path "aws-master-account/*"
{
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}
path "sys/policy/"
{
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}
path "sys/policy/*"
{
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}
path "sys/policies/"
{
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}
path "sys/policies/*"
{
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}
path "sys/mounts/example/"
{
  capabilities = ["create", "read", "update", "patch", "delete", "list"]
}
path "example/*"
{
  capabilities = ["create", "read", "update", "patch", "delete", "list"]
}
