variable "aws_region" {
    description = "AWS Region for Vault AWS Secret Role"
    default = "ap-southeast-1"
}

variable "user_list" {
    description = "AWS IAM User Name"
    default = ["vault-static-user01", "vault-static-user02", "vault-static-user03", "vault-static-user04", "vault-static-user05" ]
}

variable "rotation_period" {
    description = "User Counts to create"
    default = "120"
}

variable "inline_po_name" {
    description = "Vault Policy Name"
    type = string
    default = "vault-admin-policy"
}
