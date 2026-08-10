resource "aws_secretsmanager_secret" "argocd_github_oauth" {
  name        = "${var.project_name}-${var.env}-argocd-github-oauth"
  description = "GitHub OAuth Client ID/Secret cho Argo CD SSO"
}