provider "aws" {
  region = "us-east-1"
}

# Criando a VPC
resource "aws_vpc" "VPC-ADT" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  tags = {
    "name" = "VPC-ADT"
  }
}

# Criando a Subnet Publica A na AZ 1a

resource "aws_subnet" "PublicSubnetA" {
  vpc_id            = aws_vpc.VPC-ADT.id
  cidr_block        = "10.0.0.0/24"
  availability_zone = "us-east-1a"
  tags = {
    "name" = "Public_A"
  }
}

# Criando a Subnet Publica B na AZ 1b

resource "aws_subnet" "PublicSubnetB" {
  vpc_id            = aws_vpc.VPC-ADT.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1b"
  tags = {
    "name" = "Public_B"
  }
}

# Criando a Subnet Privada A para Frontend na AZ 1a

resource "aws_subnet" "PrivateSubnetA" {
  vpc_id            = aws_vpc.VPC-ADT.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1a"
  tags = {
    name = "Private_FE"
  }
}

resource "aws_subnet" "PrivateSubnetB" {
  vpc_id            = aws_vpc.VPC-ADT.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "us-east-1a"
  tags = {
    "name" = "Private_BE"
  }
}

resource "aws_subnet" "PrivateSubnetC" {
  vpc_id            = aws_vpc.VPC-ADT.id
  cidr_block        = "10.0.4.0/24"
  availability_zone = "us-east-1a"
  tags = {
    "name" = "Private_DB_A"
  }
}

resource "aws_subnet" "PrivateSubnetD" {
  vpc_id            = aws_vpc.VPC-ADT.id
  cidr_block        = "10.0.5.0/24"
  availability_zone = "us-east-1b"
  tags = {
    "name" = "Private_DB_B"
  }
}

resource "aws_instance" "BastionHost" {
  ami           = "ami-0fa60543f60171fe3"
  instance_type = "t2.micro"
  subnet_id   = aws_subnet.PublicSubnetA.id
  tags = {
    "name" = "BastionHost"
  }
}

resource "aws_instance" "Ansible-Jenkins" {
  ami           = "ami-09e67e426f25ce0d7"
  instance_type = "t2.micro"
  subnet_id   = aws_subnet.PrivateSubnetA.id
  tags = {
    "name" = "Ansible-Jenkins"
  }
}

resource "aws_instance" "WebServerFE" {
  ami           = "ami-09e67e426f25ce0d7"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.PrivateSubnetA.id
  tags = {
    "name" = "WebServer_FE"
  }
}

resource "aws_instance" "WebServerBE" {
  ami           = "ami-09e67e426f25ce0d7"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.PrivateSubnetB.id
  tags = {
    "name" = "WebServer_BE"
  }
}

resource "aws_db_instance" "DBServer" {
  allocated_storage    = 10
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t2.micro"
  name                 = "adtsysdb"
  username             = "admin"
  password             = "Kiw23DScvbA1*"
  skip_final_snapshot  = true
  db_subnet_group_name = aws_db_subnet_group.db-net-group.id
}

resource "aws_db_subnet_group" "db-net-group" {
  name       = "dbsubnet"
  subnet_ids = [aws_subnet.PrivateSubnetC.id, aws_subnet.PrivateSubnetD.id]
}

resource "aws_eip" "NAT" {
  vpc        = true
  depends_on = [aws_internet_gateway.IGW]
  tags = {
    "name" = "ElasticIP"
  }
}

resource "aws_internet_gateway" "IGW" {
  vpc_id = aws_vpc.VPC-ADT.id
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