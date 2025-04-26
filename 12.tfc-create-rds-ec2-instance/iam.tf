//-------------------------------------------------------------------------------------
// Create IAM Instance Profile for Vault Auth IAM Role
//-------------------------------------------------------------------------------------

resource "aws_iam_instance_profile" "vault-client" {
  name = "${var.environment_name}-vault-client-instance-profile"
  role = data.aws_iam_role.vault-client.id
}


data "aws_iam_role" "vault-client" {
  name = var.vault-client_role
}

