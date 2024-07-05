# default - стандартные значения 
# type - тип видение строки
# variable варианты выбора


variable "region"{
	description = "Please Enter AWS Region to deploy Server"
	type = string
	default = "eu-west-1"
}



variable "instance_type"{
	description = "Enter Instace Type"
	type = string
	default = "t2.micro"
}

variable "allow_ports"{
	description = "List of Ports to open for Server"
	type = list
	default = ["80" , "443" , "22"]
}

variable "cidr_blocks_ip"{
	description = "List of IP to open for Serverr"
	type = string
	default = ["0.0.0.0/0"]
}

variable "enable_detailed_monitoring" {
	type = bool
	default = false
}

variable "comon_tags"{
	description = "Common Tags to apply to all resources"
	type = map
	default = {
	Owner = "DiShu"
  	Project = "Ubuntu20"
	}
}