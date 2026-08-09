variable "project_name" {
  type = string
}

variable "env" {
  type = string
}

variable "eks_cluster_version" {
    type = string
}

variable "private_subnet_ids" {
  type = list(string)
}

variable "eks_node_group_capacity_type" {
  type = string
}

variable "eks_node_group_instance_type" {
  type = list(string)
}
