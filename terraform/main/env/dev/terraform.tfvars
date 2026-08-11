project_name = "gitops_cicd_3_tiers"
region = "ap-southeast-1"
env = "dev"
eks_cluster_version = "1.36"
eks_node_group_capacity_type = "SPOT"
eks_node_group_instance_type = "t3.small"

eks_addon_versions = {
  coredns                  = "v1.14.2-eksbuild.4"
  kube_proxy               = "v1.35.3-eksbuild.5"
  vpc_cni                  = "v1.21.1-eksbuild.7"
  eks_pod_identity_agent   = "v1.3.10-eksbuild.2"
  cloudwatch_observability = "v6.0.1-eksbuild.1"
}
