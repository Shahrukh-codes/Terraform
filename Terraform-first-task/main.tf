# provider

provider "aws" {
  region = "ap-south-1"
}

# VPC 
resource "aws_vpc" "main_vpc" {
    cidr_block = "10.0.0.0/16"
  
  tags = {
    Name = "main_vpc"
  }
}

# subnet
resource "aws_subnet" "main_subnet" {
  vpc_id = aws_vpc.main_vpc.id
  cidr_block = "10.0.0.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name = "main_subnet"
  }
}

# internet gateway
resource "aws_internet_gateway" "gateway" {
  vpc_id = aws_vpc.main_vpc.id
}

# route table
resource "aws_route_table" "main_roottable" {
vpc_id = aws_vpc.main_vpc.id

route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gateway.id
}
tags = {
    Name = "main_roottable"
}
}

# link subnet with route table
resource "aws_route_table_association" "a"{
    subnet_id = aws_subnet.main_subnet.id
    route_table_id = aws_route_table.main_roottable.id
}

# security group 
resource "aws_security_group" "allow_ssh" {
  name = "allow_ssh"
  description = "Allow ssh inbound traffic"
  vpc_id = aws_vpc.main_vpc.id

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress  {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# EC2
resource "aws_instance" "my_instance" {
  ami = "ami-02d26659fd82cf299"
  instance_type = "t2.micro"
  subnet_id = aws_subnet.main_subnet.id
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]
  key_name = "terr-vpc-key"

  tags = {
    Name = "my_instance"
  }
}

# output
output "instance_public_ip" {
  value = aws_instance.my_instance.public_ip
}
