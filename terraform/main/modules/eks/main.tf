resource "aws_eks_cluster" "eks_cluster" {
  name = "${var.project_name}-${var.env}-eks-cluster"
  version = var.eks_cluster_version
  role_arn = aws_iam_role.eks_cluster_role.arn
#   bootstrap_self_managed_addons = true //default is true (false when use auto mode)
  vpc_config {
    subnet_ids = var.private_subnet_ids
    endpoint_private_access = true
    endpoint_public_access = true
  }

  access_config {
    authentication_mode = "API"
    bootstrap_cluster_creator_admin_permissions = true
  }
  depends_on = [aws_iam_role_policy_attachment.eks_AmazonEKSClusterPolicy]
}

resource "aws_eks_node_group" "eks_node_group" {
  cluster_name = aws_eks_cluster.eks_cluster.name
  node_group_name = "${var.project_name}-${var.env}-node-group"
  version = var.eks_cluster_version
  node_role_arn = aws_iam_role.eks_worker_role.arn

  subnet_ids = var.private_subnet_ids

  capacity_type = var.eks_node_group_capacity_type
  
  instance_types = var.eks_node_group_instance_type

  scaling_config {
    desired_size = 1
    max_size     = 3
    min_size     = 1
  }

  update_config {
    max_unavailable = 1
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks_AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.eks_AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.eks_AmazonEC2ContainerRegistryReadOnly
  ]

}

data "tls_certificate" "eks" {
  url = aws_eks_cluster.eks_cluster.identity[0].oidc[0].issuer
}

resource "aws_iam_openid_connect_provider" "this"{
  url = aws_eks_cluster.eks_cluster.identity[0].oidc[0].issuer
  client_id_list = [
    "sts.amazonaws.com"
  ]

  thumbprint_list = [
    data.tls_certificate.eks.certificates[0].sha1_fingerprint
  ]

  tags = {
    Name = "${var.project_name}-${var.env}-eks-cluster-oidc"
  }
}