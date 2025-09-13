data "aws_eks_cluster_auth" "hacka_cluster_auth" {
  name = aws_eks_cluster.hacka_cluster.name
}

data "aws_iam_role" "labrole" {
  name = "LabRole"
}