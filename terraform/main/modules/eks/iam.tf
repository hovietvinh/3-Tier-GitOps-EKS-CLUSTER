# role for eks control plane
data "aws_iam_policy_document" "eks_cluster_assume" {
  statement {
    effect = "Allow"
    actions = [
      "sts:AssumeRole",
      "sts:TagSession"
    ]
    principals {
      type        = "Service"
      identifiers = ["eks.amazonaws.com"]
    }
  }

}
resource "aws_iam_role" "eks_cluster_role" {
  name = "${var.project_name}-${var.env}-eks-cluster-role"
  assume_role_policy = data.aws_iam_policy_document.eks_cluster_assume.json
  max_session_duration = 3600
}

resource "aws_iam_role_policy_attachment" "eks_AmazonEKSClusterPolicy"{
  role = aws_iam_role.eks_cluster_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

# role for worker node
data "aws_iam_policy_document" "eks_worker_assume" {
  statement {
    effect = "Allow"
    actions = [
      "sts:AssumeRole",
    ]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}
resource "aws_iam_role" "eks_worker_role" {
  name = "${var.project_name}-${var.env}-eks-worker-role"
  assume_role_policy = data.aws_iam_policy_document.eks_worker_assume.json
}


resource "aws_iam_role_policy_attachment" "eks_AmazonEKSWorkerNodePolicy" {
  role = aws_iam_role.eks_worker_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

resource "aws_iam_role_policy_attachment" "eks_AmazonEKS_CNI_Policy" {
  role = aws_iam_role.eks_worker_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

resource "aws_iam_role_policy_attachment" "eks_AmazonEC2ContainerRegistryReadOnly" {
  role       = aws_iam_role.eks_worker_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}