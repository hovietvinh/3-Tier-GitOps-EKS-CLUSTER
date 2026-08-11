module "eks" {
    source = "../../modules/eks"
    project_name = var.project_name
    env = var.env
    eks_cluster_version = var.eks_cluster_version
    eks_node_group_capacity_type = var.eks_node_group_capacity_type
    eks_node_group_instance_type = var.eks_node_group_instance_type
    eks_addon_versions = var.eks_addon_versions
}

module "iam" {
    source = "../../modules/iam"
    project_name = var.project_name
    env = var.env
}

module "alb_controller_irsa" {
  source                = "../../modules/irsa"
  env                    = var.env
  project_name = var.project_name
  namespace              = "kube-system"
  service_account_name  = "aws-load-balancer-controller"
  role_name_override    = "${var.project_name}-${var.env}-alb-controller"
  oidc_provider_arn      = module.eks.oidc_provider_arn
  oidc_provider_url      = module.eks.oidc_provider_url

  policy_arns = {
    alb_controller = module.iam.alb_controller_arn
  }
  depends_on = [module.eks]
}