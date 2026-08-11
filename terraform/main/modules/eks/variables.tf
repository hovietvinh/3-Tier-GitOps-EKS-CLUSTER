variable "project_name" {
  type = string
}

variable "env" {
  type = string
}

variable "eks_cluster_version" {
    type = string
}


variable "eks_node_group_capacity_type" {
  type = string
}

variable "eks_node_group_instance_type" {
  type = list(string)
}

variable "eks_addon_versions" {
  type = object({
    coredns                      = string
    kube_proxy                   = string
    vpc_cni                      = string
    eks_pod_identity       = string
  })
  description = "Pinned versions for EKS add-ons"
}