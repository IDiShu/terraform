variable "env" {
  default = "dev"
}

variable "prod_onwer" {
  default = "DiShu"
}

variable "noprod_owner" {
  default = "Default Name"
}

variable "ec2_size" {
  default = {
    "prod"    = "t3.medium"
    "dev"     = "t3.micro"
    "staging" = "t2.small"
  }
}

variable "allow_port_list" {
  default = {
    "prod" = ["80", "443"]
    "dev"  = ["80", "443", "8080", "22"]
  }
}