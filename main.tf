provider "aws" {
  region = "us-east-1"
}

# Criando a VPC
resource "aws_vpc" "VPC-SERASA" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  tags = {
    "name" = "VPC-SERASa"
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

resource "aws_eip" "NIG" {
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
  allocation_id = aws_eip.NAT.id
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

#resource "aws_elb" "PublicALB" {
#    name = "PublicALB"
#    availability_zones = ["us-east-1a","us-east-1b"]
#    listener {
#      instance_port = 8000
#      instance_protocol = "http"
#      lb_port = 80
#      lb_protocol = "http"
#    }
#    health_check {
#      healthy_threshold = 2
#      unhealthy_threshold = 2
#      timeout = 3
#      target = "HTTP:8000/"
#      interval = 30
#    }
#    instances = [aws_instance.WebServerFE.id]
#    cross_zone_load_balancing = true
#    idle_timeout = 400
#    connection_draining = true
#    connection_draining_timeout = 400
#    tags = {
#      "name" = "ALB_FE"
#    }
#}

#resource "aws_elb" "InternalALB" {
#    name = "InternalALB"
#    availability_zones = ["us-east-1a","us-east-1b"]
#    listener {
#      instance_port = 8000
#      instance_protocol = "http"
#      lb_port = 8080
#      lb_protocol = "http"
#    }
#    health_check {
#      healthy_threshold = 2
#      unhealthy_threshold = 2
#      timeout = 3
#      target = "HTTP:8000/"
#      interval = 30
#    }
 #   instances = [aws_instance.WebServerBE.id]
 #   cross_zone_load_balancing = true
 #   idle_timeout = 400
 #   connection_draining = true
 #   connection_draining_timeout = 400
 #   tags = {
 #     "name" = "ALB_BE"
 #   }
#}