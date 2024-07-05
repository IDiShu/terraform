output "WebServer_instance_id"{
  value = aws_instance.my_ubuntu.id
}

output "WebServer_publick_ip_address"{
  value = aws_eip.my_static_ip.public_ip
}

output "WebServer_sg_id"{
  value = aws_security_group.my_ubuntu.id
}

output "WebServer_sg_arn"{
  value = aws_security_group.my_ubuntu.arn
}

output "data_aws_availability_zones"{
  value = data.aws_availability_zones.working.names
}

output "data_aws_caller_identity"{
  value = data.aws_caller_identity.current.account_id
}

output "data_aws_region"{
  value = data.aws_region.current.name
}

output "data_aws_region_description"{
  value = data.aws_region.current.description
}

# output "data_aws_vpc"{
#   value = data.aws_vpc.prod_vpc.id
# }

# output "data_aws_vpc_cidr"{
#   value = data.aws_vpc.prod_vpc.cidr_block
# }

