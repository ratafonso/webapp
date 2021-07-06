provider "aws" {
  region = "us-east-1"
}

# Criando a VPC
resource "aws_vpc" "myvpc" {
  cidr_block           = "10.0.0.0/16"
  instance_tenancy = "default"
  enable_dns_hostnames = true
  tags = {
    Name = "MyVPC"
  }
}
# Finalizado a criação da VPC

# Criando a Subnet Publica A na AZ 1a
resource "aws_subnet" "PublicSubnetA" {
  vpc_id            = aws_vpc.myvpc.id
  cidr_block        = "10.0.0.0/24"
  availability_zone = "us-east-1a"
  tags = {
    Name = "Public_A"
  }
}
# Finalizado a criação da Subnet Publica A

# Criando o Security Group para o servidor Web
resource "aws_security_group" "mysg" {
  name = "WEB-HTTP-HTTPS"
  description = "Allowing HTTP and HTTPS Traffic"
  vpc_id = "${aws_vpc.myvpc.id}"

  ingress {
    description = "Allow SSH"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow HTTP"
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  ingress {
    description = "Allow TOMCAT HTTP"
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow HTTPS"
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow access Internet"
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    "Name" = "MySG"
  }
}
# Finalizando a criação do Security Group

# Criando a Instância EC2 para o servidor de aplicação Web
resource "aws_instance" "webserver" {
  ami           = "ami-09e67e426f25ce0d7"
  instance_type = "t2.micro"
  key_name = "serasa-key"
  availability_zone = "us-east-1a"
  vpc_security_group_ids = [aws_security_group.mysg.id]
  subnet_id     = aws_subnet.PublicSubnetA.id
  user_data = <<-EOF
                #!/bin/bash
                sudo apt update -y
                sudo apt upgrade -y
                sudo apt install curl apt-transport-https ca-certificates software-properties-common -y
                sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
                sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
                sudo apt update
                sudo apt-cache policy docker-ce docker.io container.io
                sudo apt install docker-ce
                sudo systemctl enable docker-ce
                sudo systemctl start docker-ce
                sudo apt install nginx
                sudo systemctl enable nginx
                sudo systemctl start nginx
                sudo usermod -aG docker ubuntu
                EOF
  tags = {
    Name = "webserver1"
  }
}
# Finalizado a criacao da instancia EC2 para a Aplicacao Web

# Criando Elastic IP para o servidor Web
resource "aws_eip" "MyEIP" {
  vpc        = true
  instance = aws_instance.webserver.id
  depends_on = [aws_internet_gateway.IGW]
  tags = {
    Name = "ElasticIP-webserver1"
  }
}
# Finalizado a criacao do Elastic IP

# Criando Internet Gateway
resource "aws_internet_gateway" "IGW" {
  vpc_id = "${aws_vpc.myvpc.id}"
  tags = {
    Name = "IGW"
  }
}
# Finalizado a criacao do Internet Gateway