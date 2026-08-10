data "aws_iam_policy_document" "assume_role" {
  statement{
    effect  = "Allow"
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [var.oidc_provider_arn]
    } 

    condition {
      test     = "StringEquals"
      variable = "${replace(var.oidc_provider_url, "https://", "")}:sub"
      values = [
        "system:serviceaccount:${var.namespace}:${var.service_account_name}"
      ]
    }

    condition {
      test     = "StringEquals"
      variable = "${replace(var.oidc_provider_url, "https://", "")}:aud"
      values   = ["sts.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "this" {
  name               = coalesce(var.role_name_override, "${var.project_name}-${var.env}-${var.service_account_name}")
  assume_role_policy = data.aws_iam_policy_document.assume_role.json

  tags = {
    env       = var.env
    namespace = var.namespace
    service   = var.service_account_name
  }
}

resource "aws_iam_role_policy_attachment" "this" {
  for_each = var.policy_arns

  role       = aws_iam_role.this.name
  policy_arn = each.value
}

resource "kubernetes_service_account_v1" "this" {
  metadata {
    name      = var.service_account_name
    namespace = var.namespace

    annotations = {
      "eks.amazonaws.com/role-arn" = aws_iam_role.this.arn
    }

    labels = {
      env = var.env
    }
  }
}