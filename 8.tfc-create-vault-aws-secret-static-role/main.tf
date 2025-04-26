resource "aws_iam_user" "vault_static_user" {
  count = length(var.user_list)
  name = var.user_list[count.index]
  path = "/"

  tags = {
    Name = var.user_list[count.index]
  }
}

resource "aws_iam_access_key" "vault_admin_accesskey" {
  count = length(var.user_list)
  user = aws_iam_user.vault_static_user[count.index].name
  lifecycle {
    ignore_changes = [
    user
    ]
  }
}

data "aws_iam_policy_document" "inline_po_vault" {
  statement {
    effect    = "Allow"
    actions   = ["iam:GetUser"]
    resources = [
		"arn:aws:iam::339713018668:user/*"
        ]
  }
}

resource "aws_iam_user_policy" "inline_po_attach" {
  count = length(var.user_list)
  name   = var.inline_po_name
  user   = aws_iam_user.vault_static_user[count.index].name
  policy = data.aws_iam_policy_document.inline_po_vault.json
}

resource "vault_aws_secret_backend_static_role" "static_role" {
  count = length(var.user_list)
  backend = data.terraform_remote_state.vault_aws_backend.outputs.backend_path
  name = var.user_list[count.index]
  username = var.user_list[count.index]
  rotation_period = var.rotation_period
}