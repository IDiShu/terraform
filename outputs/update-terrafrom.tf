provider "aws" {

	region = "eu-central-1"
}
data "aws_ami" "latest_ubuntu"{
	owners = ["099720109477"]
	most_recent = true
	filter {
		name = "name"
		values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]

	}
}

resource "aws_instance" "my_ubuntu" {
	ami = data.aws_ami.latest_ubuntu.id
	instance_type = "t2.micro"
	vpc_security_group_ids = [aws_security_group.my_ubuntu.id]
	tags = {                          
		Name = "Ubuntu server test"
		Owner = "DiShu"
		Project = "Terraform test"
	}
}

resource "aws_security_group" "my_ubuntu" { 
  name        = "WebServer Security Group"
  description = "Security Group"

  dynamic "ingress" {
  	for_each = ["80", "443" , "8080" , "9092" , "1541"]
  	content {
  		description      = "http protocol"
        from_port        = ingress.value
        to_port          = ingress.value
        protocol         = "tcp"
        cidr_blocks      = ["0.0.0.0/0"]
  	}
}
  ingress {
  	description      = "SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

output "latest_ubuntu_ami_id" {
	value = data.aws_ami.latest_ubuntu.id
}

output "latest_ubuntu_ami_names" {
	value = data.aws_ami.latest_ubuntu.name
}

output "WebServer_instance_id"{
  value = aws_instance.my_ubuntu.id
}