#################################################################################
### AWS IAM User and Role
#################################################################################
variable "vault-client-role" {
  description = "AWS IAM Role for Vault Client"
  type = string
  default = "ec2-vault-client-role"
}

variable "iam_role_policy" {
  description = "AWS IAM Role Policy for Vault Client"
  type = string
  default = "ec2-vault-client-role-policy"
}

#################################################################################
### Vault AWS Auth Method
#################################################################################

variable "aws_master_auth" {
  description = "AWS Auth Path"
  type = string
  default = "master-aws-auth"
}

variable "aws_auth_role" {
  description = "AWS Auth Role"
  type = string
  default = "ec2-role"
}

variable "role_type" {
  description = "AWS Auth Role Type"
  type = string
  default = "iam"
}

variable "db_policy" {
  description = "Vault DB Policy"
  type = string
  default = "db-policy"
}
