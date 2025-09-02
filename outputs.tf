# Output para exibir o ID da VPC criada
output "vpc_id" {
  value       = aws_vpc.hacka_vpc.id
  description = "O ID da VPC criada"
}

output "eks_cluster_name" {
  value = aws_eks_cluster.hacka_cluster.name
}

output "bucket_name" {
  description = "O nome do bucket S3 criado."
  value       = aws_s3_bucket.bucket-hacka.bucket
}