#----------------------------------------------------------------------------------------------------
#My Terraform 
#
#Build test WebServer
#---------------------------------------------------------------------------------------------------

# команда которая показывает терраформу какой сервис мы используем
provider "aws" {
	# это мы удаляем если мы будем пушить в гит 
  access_key = "AKIAZVVFEWHSX4U77JQJ"
  # это мы удаляем если мы будем пушить в гит 
	secret_key = "dWfGGMVMeUpbD6Wi3QhIbPtU7/K6ZbiU5g0VQtRY" 
	region = "eu-central-1"
}
data "aws_availability_zones" "working" {}
data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

# Создание VPC зоны для сервера
# data "aws_vpc" "prod_vpc" {
#   tags = {
#     Name = "my_ubuntu"
#   }
# }

# resource "aws_subnet" "prod_subnet_1" {
# vpc_id = data.aws_vpc.prod_vpc.id
# availability_zone = data.aws_availability_zones.working.names[1]
# cidr_block = "10.10.1.0/24"
# tags = {
#   Name = "Subnet-1 in ${data.aws_availability_zones.working.names[1]}"
#   Account = "Subnet-1 Account ${data.aws_caller_identity.current.account_id}"
#   Region = data.aws_region.current.description
#   }
# }


# Приатачивание эластик IP к серверу
resource "aws_eip" "my_static_ip" {
  instance = aws_instance.my_ubuntu.id
}
# команда для создания инстанса под именем my_ubuntu
resource "aws_instance" "my_ubuntu" { 
	# команда которая показывает сколько нужно создать инстансов (так же терраформ может удалять сервера , если изменить число серверов с 3 к 1 или же к 0 )
  #count = 1
	# команда которая показывает что мы хотим установить
  ami = "ami-04e601abe3e1a910f"     
	# команда для выбора типа инстанса (можно изменять параметр рессурса)
  instance_type = "t2.micro"        
	# комадна для приатачивание нескольких или уже созданных групп
  vpc_security_group_ids = [aws_security_group.my_ubuntu.id]     
	# путь к файлу который находиться на нашем локальном сервере (bash) так же можно использовать динамичные переменные в кофигурации по типу (l_name = "Имя" или же просто names = [имена])
  user_data = file("/home/user/dd/user_data.sh") 
# команда для создания тэгов к сереверу и работы (маленькая документация)
	tags = {                          
		Name = "Ubuntu server test"
		Owner = "DiShu"
		Project = "Terraform test"
	}
# делает порядок создания серверов , только нужно прописывать порядок кто за кем создается 
  depends_on = [aws_instance.my_ubuntu]
}
# создание группы безопасности к серверу 
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
