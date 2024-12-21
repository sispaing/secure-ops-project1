variable "cloud_provider" {
    description = "Cloud Provider Name"
    type = string
    default = "aws"
}

variable "region" {
    description = "Cloud Provider Region Name"
    type = string
    default = "ap-southeast-1"
}

variable "cluster_cider" {
    description = "Cluster CIDR Block"
    type = string
    default = "172.23.16.0/20"
}

variable "vault_cluster_id" {
    description = "Cluster Name"
    type = string
    default = "hcp-vault-cluster"
}

variable "vault_hvn" {
    description = "HCP HVN ID"
    type = string
    default = "vault-aws-hvn"
}

variable "tier_type" {
    description = "Vault Cluster Tier Type"
    type = string
    default = "starter_small"
}

variable "vault_version" {
    description = "Vault Cluster Minimum Version"
    type = string
    default = "1.16.2"
}