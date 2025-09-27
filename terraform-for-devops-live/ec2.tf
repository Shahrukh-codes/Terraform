# key pair

resource "aws_key_pair" "my_key" {
    key_name = "terra-key-ec2"
    public_key = file("terra-key-ec2.pub")
}

# VPS & Security Group

resource "aws_default_vpc" "default" {

  }

resource aws_security_group my_security_group {
    name = "automate-sg"
    description = "this will add a TF generated Security group"
    vpc_id = aws_default_vpc.default.id # interpolation

   # inbound rules 
    ingress{
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        description = "SSH open"
    }

    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        description = "HTTP open"
    }

    ingress{
        from_port = 8000
        to_port = 8000
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        description = "Flask app"
    }

   # outbound rules
    egress{
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
        description = "all access open outbound"
        
    }

    tags = {
        Name = "automate-sg"
    }
}

# ec2 instance

resource "aws_instance" "my_instance" {
    key_name = aws_key_pair.my_key.key_name
    security_groups = [aws_security_group.my_security_group.name]
    instance_type = var.ec2_instance_type
    ami = var.ec2_ami_id # ubuntu
   
    root_block_device {
        volume_type = "gp3"
        volume_size = var.ec2_root_storage_size
    }
    tags = {
      Name = "TWS-Junnon-automate"
    }
}