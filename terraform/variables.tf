variable "region" {
  default = "ap-south-1"
}
variable "availability_zones" {
  default = ["ap-south-1a","ap-south-1b","ap-south-1c"]
}
variable "key_name" {
  default = "kb.2pirad"
}
variable "instance_type" {
  default = "t2.nano"
}
variable "asg_min" {
  default = "2"
}
variable "asg_max" {
  default = "5"
}
variable "asg_desired" {
  default = "2"
}

variable "amis" {
  default = {
    us-west-2 = "ami-60b6c60a"
    ap-south-1 = "ami-005956c5f0f757d37"
  }
}
variable "vpc_cidr" {
  default = "10.0.0.0/16"
}
variable "public_subnet_cidr" {
  default = "10.0.0.0/24"
}
variable "private_subnet_cidr" {
  default = "10.0.1.0/24"
}
