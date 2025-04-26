//-------------------------------------------------------
//-Create AWS IAM User for AWS Auth
//-------------------------------------------------------
resource "aws_iam_user" "vault_aws_auth" {
  name = var.aws_master_auth
  path = "/"

  tags = {
    Name = var.aws_master_auth
  }
}

resource "aws_iam_access_key" "vault_auth_accesskey" {
  user = aws_iam_user.vault_aws_auth.name
  lifecycle {
    ignore_changes = [
    user
    ]
  }
}

resource "aws_iam_user_policy" "inline_po_attach" {
  name   = var.aws_master_auth
  user   = aws_iam_user.vault_aws_auth.name
  policy = data.aws_iam_policy_document.vault-server.json
}

//-------------------------------------------------------
//-Create AWS IAM role for AWS Auth Role and EC2
//-------------------------------------------------------

resource "aws_iam_role" "vault-client" {
  name               = var.vault-client-role
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_iam_role_policy" "vault-client" {
  name   = var.iam_role_policy
  role   = aws_iam_role.vault-client.id
  policy = data.aws_iam_policy_document.vault-client.json
}


//--------------------------------------------------------------------
// Data Sources

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "vault-server" {
  statement {
    sid    = "VaultAWSAuthMethod"
    effect = "Allow"
    actions = [
        "ec2:DescribeInstances",
        "iam:GetInstanceProfile",
        "iam:GetUser",
        "iam:ListRoles",
        "iam:GetRole"
     ]
    resources = ["*"]
  } 
}

data "aws_iam_policy_document" "vault-client" {
  statement {
    sid    = "ConsulAutoJoin"
    effect = "Allow"

    actions = ["ec2:DescribeInstances"]

    resources = ["*"]
  }
}