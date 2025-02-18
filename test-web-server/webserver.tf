provider "aws" {
    access_key = ""
	secret_key = "" 
	region = "eu-west-1"
}
data "aws_availability_zones" "available" {}
data "aws_ami" "latest_ubuntu"{
	owners = ["099720109477"]
	most_recent = true
	filter {
		name = "name"
		values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]

	}
}

resource "aws_launch_configuration" "web" {
  # name          = "WebServer-Test-LC"
  name_prefix   = "WebServer-Test-LC"
  image_id      = data.aws_ami.latest_ubuntu.id
  instance_type = "t2.micro"
  security_groups = [aws_security_group.my_ubuntu.id]
  user_data = file("user_data.sh")

  lifecycle{
  	create_before_destroy = true
  }
}

resource "aws_security_group" "my_ubuntu" { 
  name        = "WebServer Security Group"
  description = "Security Group"

  dynamic "ingress" {
  	for_each = ["80","443","22"]
  	content {
  		description      = "default protocol"
        from_port        = ingress.value
        to_port          = ingress.value
        protocol         = "tcp"
        cidr_blocks      = ["0.0.0.0/0"]
  	}
}

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
  	Name = "Dynamic SecurityGrup"
  	Owner = "DiShu"
  }
}

resource "aws_autoscaling_group" "web" {
  name                 = "ASG-${aws_launch_configuration.web.name}"
  launch_configuration = aws_launch_configuration.web.name
  max_size             = 5
  min_size             = 2
  min_elb_capacity     = 2
  vpc_zone_identifier  = [aws_default_subnet.default_az1.id, aws_default_subnet.default_az2.id]
  health_check_type    = "ELB"
  load_balancers       = [aws_elb.web.name]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_elb" "web" {
	name               = "WebServer-in-elb"
	availability_zones = [data.aws_availability_zones.available.names[0],data.aws_availability_zones.available.names[1]]
	security_groups = [aws_security_group.my_ubuntu.id]
	listener {
		lb_port           = 80
		lb_protocol       = "HTTP"
		instance_port     = 80
		instance_protocol = "HTTP"
	}
	health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:80/"
    interval            = 10
  }
  tags = {
  	Name = "WebServer-in-elb"
  }
}


resource "aws_default_subnet" "default_az1" {
  availability_zone = data.aws_availability_zones.available.names[0]
}
  resource "aws_default_subnet" "default_az2" {
  availability_zone = data.aws_availability_zones.available.names[1]
}

output "web_loadbalancer_url" {
	value = aws_elb.web.dns_name
}
