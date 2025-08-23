terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.46"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.32.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.13.2"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = var.aws_region
}

provider "kubernetes" {
  host                   = aws_eks_cluster.hacka_cluster.endpoint
  cluster_ca_certificate = base64decode(aws_eks_cluster.hacka_cluster.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.hacka_cluster_auth.token
}

#Configuração do provedor Helm para se conectar ao EKS
provider "helm" {
  kubernetes {
    host                   = aws_eks_cluster.hacka_cluster.endpoint
    cluster_ca_certificate = base64decode(aws_eks_cluster.hacka_cluster.certificate_authority[0].data)
    token                  = data.aws_eks_cluster_auth.hacka_cluster_auth.token
  }
}