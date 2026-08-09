module "eks" {
    source = "../../modules/eks"
    project_name = var.project_name
    env = var.env
    eks_cluster_version = var.eks_cluster_version
    private_subnet_ids = var.private_subnet_ids
    eks_node_group_capacity_type = var.eks_node_group_capacity_type
    eks_node_group_instance_type = var.eks_node_group_instance_type
}