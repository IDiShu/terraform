#-------------------------------------------------------------------------------
# My Terraform
#
# Local Variables
#
# Made by DiShu
#
#
# az_list = join(",", data.aws_availability_zones.available.names): В этой строке создается переменная az_list, которая будет содержать имена зон доступности (Availability Zones) в текущем AWS регионе, разделенные запятыми. Это достигается с помощью функции join, которая объединяет элементы массива (в данном случае, имена зон доступности) в одну строку, разделяя их запятыми.
#
# region = data.aws_region.current.description: В этой строке создается переменная region, которая будет содержать описание текущего AWS региона. data.aws_region.current - это ресурс Terraform, который предоставляет информацию о текущем AWS регионе, а .description извлекает описание этого региона.
#
# location = "In ${local.region} there are AZ: ${local.az_list}": Здесь создается переменная location, которая будет содержать строку с информацией о местоположении (location). Эта строка содержит две подстановки:
#
# ${local.region} заменяется значением переменной region, которая была определена ранее и содержит описание текущего AWS региона.
#
# ${local.az_list} заменяется значением переменной az_list, которая была определена ранее и содержит список имен зон доступности.
#-------------------------------------------------------------------------------

provider "aws" {
	region = "eu-central-1"
}

data "aws_region" "current"{}
data "aws_availability_zones" "available"{}

# локальная переменная которая комбинирует несколько вещей
locals {
	full_project_name = "${var.environment}-${var.project_name}"
	project_owner = "${var.owner} owner of ${var.project_name}"
}

locals {
	country = "Canada"
	city = "Deadmonton"
	#join(",", ...) - Эта команда объединяет элементы массива в одну строку, разделяя их запятой. В данном случае, она берет массив имен зон доступности и объединяет их в одну строку, разделяя запятыми.
	az_list = join(",", data.aws_availability_zones.available.names)
	region = data.aws_region.current.description
	location = "In ${local.region} there are AZ: ${local.az_list}"
}

resource "aws_eip" "my_static_ip" {
	tags = {
	Name = "Static IP"
	Owner = var.owner
	Project = local.full_project_name
	Proj_owner = local.project_owner
	region_azs = local.az_list
	location = local.location
	}
}