variable "auth_backend_type" {
  description = "Backend type for Approle Auth Method"
  default = "approle"
}

variable "auth_backend_path" {
  description = "Approle Auth Backend Path"
  default = "tfc-approle"
}

variable "db_secret_policy" {
  description = "db Secret Policy Name for Approle"
  default = "db_secret_policy"
}

variable "admin_policy" {
  description = "Admin Policy Name for Approle"
  default = "admin_secret_policy"
}

variable "db_approle_role_name" {
  description = "db Role Name for Approle"
  default = "db-secret-approle"
}

variable "admin_approle_role_name" {
  description = "Admin Role Name for Approle"
  default = "admin-approle"
}