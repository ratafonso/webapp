provider "aws" {
  region = "us-east-1"
}

# Criando a VPC
resource "aws_vpc" "VPC-SERASA" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  tags = {
    "name" = "VPC-SERASA"
  }
}

# Criando a Subnet Publica A na AZ 1a

resource "aws_subnet" "PublicSubnetA" {
  vpc_id            = aws_vpc.VPC-SERASA.id
  cidr_block        = "10.0.0.0/24"
  availability_zone = "us-east-1a"
  tags = {
    "name" = "Public_A"
  }
}

# Criando a Subnet Publica B na AZ 1b

resource "aws_subnet" "PublicSubnetB" {
  vpc_id            = aws_vpc.VPC-SERASA.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1b"
  tags = {
    "name" = "Public_B"
  }
}

resource "aws_eip" "EIP" {
  vpc        = true
  depends_on = [aws_internet_gateway.IGW]
  tags = {
    "name" = "ElasticIP"
  }
}

resource "aws_internet_gateway" "IGW" {
  vpc_id = aws_vpc.VPC-SERASA.id
  tags = {
    "name" = "IGW"
  }
}

resource "aws_nat_gateway" "NAT_GW" {
  allocation_id = aws_eip.EIP.id
  subnet_id     = aws_subnet.PrivateSubnetA.id
  depends_on = [aws_internet_gateway.IGW]
  tags = {
    "name" = "NAT_GW"
  }
}

resource "aws_route_table" "Rotas" {
  vpc_id = aws_vpc.VPC-ADT.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.NAT_GW.id
  }

}

resource "aws_route_table_association" "assoc" {
  subnet_id      = aws_subnet.PrivateSubnetA.id
  route_table_id = aws_route_table.Rotas.id
}
