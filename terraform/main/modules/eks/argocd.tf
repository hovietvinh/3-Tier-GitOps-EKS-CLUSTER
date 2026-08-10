resource "helm_release" "argocd" {
  name = "argocd"
  repository = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  namespace        = "argocd"
  create_namespace = true
  version          = "7.3.4"
  depends_on = [
    aws_eks_cluster.eks_cluster,
    aws_eks_node_group.eks_node_group
  ]
}

data "aws_secretsmanager_secret" "argocd_github_oauth" {
  name = "${var.project_name}-${var.env}-argocd-github-oauth"
}

data "aws_secretsmanager_secret_version" "argocd_github_oauth" {
  secret_id = data.aws_secretsmanager_secret.argocd_github_oauth.id
}

locals {
  argocd_github_oauth = jsondecode(data.aws_secretsmanager_secret_version.argocd_github_oauth.secret_string)
}

resource "kubernetes_secret" "argocd_github_oauth" {
  metadata {
    name      = "argocd-github-oauth"
    namespace = "argocd"
  }
  data = {
    client_id     = local.argocd_github_oauth.client_id
    client_secret = local.argocd_github_oauth.client_secret
  }
  depends_on = [helm_release.argocd]
}