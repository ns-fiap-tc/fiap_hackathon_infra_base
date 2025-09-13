# VPC
resource "aws_vpc" "hacka_vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true

  tags = {
    Name = "hacka_vpc"
  }
}

# Subnets públicas
resource "aws_subnet" "hacka_public_subnet_1" {
  vpc_id            = aws_vpc.hacka_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "${var.aws_region}a"
  map_public_ip_on_launch = true
  tags = {
    Name = "hacka_public_subnet_1"
  }
}

resource "aws_subnet" "hacka_public_subnet_2" {
  vpc_id            = aws_vpc.hacka_vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "${var.aws_region}b"
  map_public_ip_on_launch = true
  tags = {
    Name = "hacka_public_subnet_2"
  }
}

# Subnets Privadas
resource "aws_subnet" "hacka_private_subnet_1" {
  vpc_id            = aws_vpc.hacka_vpc.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "${var.aws_region}a"
  map_public_ip_on_launch = true
  tags = {
    Name = "hacka_private_subnet_1"
  }
}

resource "aws_subnet" "hacka_private_subnet_2" {
  vpc_id            = aws_vpc.hacka_vpc.id
  cidr_block        = "10.0.4.0/24"
  availability_zone = "${var.aws_region}b"
  map_public_ip_on_launch = true
  tags = {
    Name = "hacka_private_subnet_2"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "hacka_app_igw" {
  vpc_id = aws_vpc.hacka_vpc.id

  tags = {
    Name = "hacka_app_igw"
  }
}

# Tabela de roteamento pública
resource "aws_route_table" "hacka_app_public_rt" {
  vpc_id = aws_vpc.hacka_vpc.id

  tags = {
    Name = "hacka_app_public_rt"
  }
}

resource "aws_route" "public_route" {
  route_table_id         = aws_route_table.hacka_app_public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.hacka_app_igw.id
}

# Associação da tabela de roteamento pública à subnet publica 1
resource "aws_route_table_association" "hacka_app_public_rt_association_1" {
  subnet_id      = aws_subnet.hacka_public_subnet_1.id
  route_table_id = aws_route_table.hacka_app_public_rt.id
}

# Associação da tabela de roteamento pública à subnet publica 2
resource "aws_route_table_association" "hacka_app_public_rt_association_2" {
  subnet_id      = aws_subnet.hacka_public_subnet_2.id
  route_table_id = aws_route_table.hacka_app_public_rt.id
}

# Tabela de roteamento privada
resource "aws_route_table" "hacka_app_private_rt" {
  vpc_id = aws_vpc.hacka_vpc.id

  tags = {
    Name = "hacka_app_private_rt"
  }
}

resource "aws_route" "private_route" {
  route_table_id         = aws_route_table.hacka_app_private_rt.id
  destination_cidr_block = "0.0.0.0/0"
  #gateway_id             = aws_internet_gateway.hacka_app_igw.id
  nat_gateway_id         = aws_nat_gateway.hacka_nat_gateway.id
}

# Associação da tabela de roteamento privada à subnet privada 1
resource "aws_route_table_association" "hacka_app_private_rt_association_1" {
  subnet_id      = aws_subnet.hacka_private_subnet_1.id
  route_table_id = aws_route_table.hacka_app_private_rt.id
}

# Associação da tabela de roteamento privada à subnet privada 2
resource "aws_route_table_association" "hacka_app_private_rt_association_2" {
  subnet_id      = aws_subnet.hacka_private_subnet_2.id
  route_table_id = aws_route_table.hacka_app_private_rt.id
}

#Cria um Elastic IP para o NAT Gateway:
resource "aws_eip" "hacka_nat_gateway_eip" {
  domain = "vpc"

  tags = {
    Name = "hacka_nat_gateway_eip"
  }
}


#Crie o NAT Gateway em uma subnet pública:
resource "aws_nat_gateway" "hacka_nat_gateway" {
  allocation_id = aws_eip.hacka_nat_gateway_eip.id
  subnet_id     = aws_subnet.hacka_public_subnet_1.id 

  tags = {
    Name = "hacka_nat_gateway"
  }

  depends_on = [aws_internet_gateway.hacka_app_igw]
}