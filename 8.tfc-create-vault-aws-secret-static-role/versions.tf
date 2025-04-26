terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.65.0"
    }
    vault = {
      source = "hashicorp/vault"
      version = "4.4.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
  access_key = data.vault_aws_access_credentials.master_iamadmin_creds.access_key
  secret_key = data.vault_aws_access_credentials.master_iamadmin_creds.secret_key
}

provider "vault" {
  address = data.terraform_remote_state.vault_cluster.outputs.vault_public_endpoint_url
  
}