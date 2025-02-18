provider "aws"{
	region = "eu-central-1"
}

variable "name" {
	default     = "DiShu"
}


resource "random_string" "rds_password" {
	lenght = 12
	special = true
	override_special = "!@#&"
	keepers = {
		keeper1 = var.name
		# keeper2 = var.name
	}
}

resource "aws_ssm_parameter" "rds_password" {
	name ="/prod/mysql"
	desription = "Master Password for RDS MYSQL"
	type = "SecureString"
	value = random_string.rds_password.result
}

data "aws_ssm_parameter" "my_rds_password"{
	name = "/prod/mysql"

	depends_on = [aws_ssm_parameter.rds_password]
}

resource "aws_db_instance" "mysql" {
  identifier          = "prod-rds"
  allocated_storage    = 10
  db_name              = "mydb"
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t3.micro"
  username             = "admin"
  password             = data.aws_ssm_parameter.my_rds_password.value
  parameter_group_name = "default.mysql5.7"
  skip_final_snapshot  = true
  apply_immediately    = true
}


output "rds_password"{
	value = data.aws_ssm_parameter.my_rds_password.value 
}