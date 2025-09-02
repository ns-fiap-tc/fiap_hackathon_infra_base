# 1. Cria o bucket S3
resource "aws_s3_bucket" "bucket-hacka" {
  # IMPORTANTE: O nome do bucket deve ser globalmente único.
  bucket = "bucket-hacka"
  force_destroy = true
}

# 2. Habilita o uso de ACLs (Listas de Controle de Acesso) no bucket
# Isso é necessário para que você possa definir um objeto como "public-read"
resource "aws_s3_bucket_ownership_controls" "controle_de_propriedade" {
  bucket = aws_s3_bucket.bucket-hacka.id

  rule {
    # "ObjectWriter" significa que quem faz o upload do objeto é o proprietário e pode definir ACLs.
    object_ownership = "ObjectWriter"
  }
}

# 3. Desabilita TODAS as configurações de bloqueio de acesso público
# Esta é a parte que atende diretamente o caso do usuário poder baixar o arquivo.
resource "aws_s3_bucket_public_access_block" "bloqueio_de_acesso_publico" {
  bucket = aws_s3_bucket.bucket-hacka.id

  # Mapeamento das configurações que você pediu:
  block_public_acls       = false # Desmarca "Block new public ACLs"
  ignore_public_acls      = false # Desmarca "Block any public ACLs"
  block_public_policy     = false # Desmarca "Block new public bucket policies"
  restrict_public_buckets = false # Desmarca "Block any public bucket policies"
}