#-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# Documentation for using the code
#-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# Блок provider определяет, какой провайдер будет использоваться для управления инфраструктурой. В данном случае, используется провайдер AWS с указанием региона eu-central-1.
#
# provider "aws" {
#   region = "eu-central-1"
# }
# 
# Блок data определяет источник данных aws_ami, который позволяет получить информацию о последнем образе Ubuntu в регионе eu-central-1, принадлежащем указанным владельцам (owners) и соответствующем определенным критериям фильтрации.
# 
# data "aws_ami" "latest_ubuntu" {
#   owners     = ["099720109477"]
#   most_recent = true

#   filter {
#     name   = "name"
#     values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
#   }
# }
# 
# Блок resource создает ресурс типа null_resource с именем command1. Этот ресурс использует провиженер local-exec, который выполняет команду локально на машине, где запущен Terraform. В данном случае, команда записывает текущую дату и время в файл log.txt.
# 
# resource "null_resource" "command1" {
#   provisioner "local-exec" {
#     command = "echo Terraform START: $(date) >> log.txt"
#   }
# }
# 
# Блок resource создает ресурс aws_launch_configuration с именем web. Этот ресурс определяет конфигурацию запуска для экземпляров Amazon EC2. Он использует образ Ubuntu, полученный из ранее определенного источника данных data.aws_ami.latest_ubuntu, и указывает тип экземпляра t2.micro. Кроме того, также определен провиженер local-exec, который выполняет команду при создании экземпляра EC2.
# 
# resource "aws_launch_configuration" "web" {
#   image_id      = data.aws_ami.latest_ubuntu.id
#   instance_type = "t2.micro"
#
#   provisioner "local-exec" {
#     command = "echo Hello from AWS Instance Creations!"
#   }
# }
# Это основные компоненты данной Terraform-конфигурации, которые определяют создание ресурсов в AWS и выполнение локальных команд. После применения этой конфигурации с помощью terraform apply, будут созданы указанные ресурсы в указанном регионе AWS.
#-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------






provider "aws"{
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

resource "null_resource" "command1"{
	provisioner "local-exec"{
	command = "echo Terraform START: $(date) >> log.txt"
	}
}

resource "aws_launch_configuration" "web" {
  image_id      = data.aws_ami.latest_ubuntu.id
  instance_type = "t2.micro"
  provisioner "local-exec"{
  	command = "echo Hello from AWS Instance Creations!"
  }
}