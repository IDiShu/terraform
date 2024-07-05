provider "aws" {
	region = var.region
}

data "aws_ami" "latest_ubuntu"{
	owners = ["099720109477"]
	most_recent = true
	filter {
		name = "name"
		values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]

	}
}

resource "aws_instance" "my_server" {
  ami      = data.aws_ami.latest_ubuntu.id
  instance_type = var.instance_type
  vpc_security_groups_ids = [aws_security_group.my_ubuntu.id]
  monitoring = var.enable_detailed_monitoring
  tags = merge(var.common_tags , {Name = "Server Build by Terraform"} , {Region = var.region})
}

  resource "aws_eip" "my_static_ip" {
  instance = aws_instance.my_server.id
  tags = merge(var.common_tags , {Name ="${var.common_tags["Environment"]} Server IP" })
}

 dynamic "ingress" {
  	for_each = var.allow_ports
  	content {
  		description      = "protocol default"
        from_port        = ingress.value
        to_port          = ingress.value
        protocol         = "tcp"
        cidr_blocks      = var.cidr_blocks_ip
  	}
}
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}
  
tags = merge(var.common_tags , {Name = "Server SecurityGroup"} , {Region = var.region})
