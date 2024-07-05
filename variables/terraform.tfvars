# Auto fill parmeters for DEV

# File can be names as:
# terrform.tfvars
# prod.auto.tfvars
# dev.auto.tfvars
# *.auto.tfvars
# *.tfvars

region = "us-west-2"
instance_type = "t2.micro"
enable_detailed_monitoring = false

allow_ports = ["80","22","8080"]

comon_tags = {
	Owner = "DiShu"
  	Project = "Ubuntu20"
	}
}