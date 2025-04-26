variable "conn_url" {
  description = "(NEED to UPDATE) A URL containing connection information."
  default = "mysql01.c9megm26srja.ap-southeast-1.rds.amazonaws.com:3306"
}

variable "Secret_path" {
  description = "Where the secret backend will be mounted"
  default = "db"
}

variable "config_name" {
  description = "Config Name"
  default = "mysqldb1"
}

variable "conn_username" {
  description = "The root credential username used in the connection URL."
  default = "vault"
}

variable "conn_password" {
  description = "The root credential password used in the connection URL."
  default = "vault"
}

variable "allowed_roles" {
  description = "A list of roles that are allowed to use this connection."
  default = ["readonly-role", "readwrite-role"]
}

variable "readonly_role" {
  description = "A unique name to give the role."
  default = "readonly-role"
}

variable "readwrite_role" {
  description = "A unique name to give the role."
  default = "readwrite-role"
}