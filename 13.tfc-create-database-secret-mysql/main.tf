resource "vault_database_secrets_mount" "db" {
  path = var.Secret_path

  mysql {
    name           = var.config_name
    username       = var.conn_username
    password       = var.conn_password
    connection_url = "{{username}}:{{password}}@tcp(${var.conn_url})/"
    allowed_roles = var.allowed_roles
  }

}

resource "vault_database_secret_backend_role" "readonly" {
  name    = var.readonly_role
  backend = vault_database_secrets_mount.db.path
  db_name = vault_database_secrets_mount.db.mysql[0].name
  default_ttl = 900
  max_ttl = 2700
  creation_statements = [
    "CREATE USER '{{name}}'@'%' IDENTIFIED BY '{{password}}';",
    "GRANT SELECT ON projectdb.* TO '{{name}}'@'%';"
  ]
}

resource "vault_database_secret_backend_role" "readwrite" {
  name    = var.readwrite_role
  backend = vault_database_secrets_mount.db.path
  db_name = vault_database_secrets_mount.db.mysql[0].name
  default_ttl = 900
  max_ttl = 2700
  creation_statements = [
    "CREATE USER '{{name}}'@'%' IDENTIFIED BY '{{password}}';",
    "GRANT ALL PRIVILEGES ON projectdb.* TO '{{name}}'@'%';"
  ]
}