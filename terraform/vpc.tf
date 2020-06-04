
resource "aws_vpc" "some_vpc" {
  cidr_block = """
  enable_dns_hostnames = true
  tags =  {
    Name = ""
  }
}

resource "aws_internet_gateway" "default" {
  vpc_id = ""
  }
}
output "vpc_id" {
  value = aws_vpc.default.id
}


resource "aws_instance" "nat" {
  ami = var.ami_ids
  availability_zone = ""
  instance_type = "t2.small"
  key_name = "${var.key_name}"
  security_groups = ["${aws_security_group.nat.id}"]
  subnet_id = "${aws_subnet.rails_public.id}"
  associate_public_ip_address = true
  source_dest_check = false
  tags =  {
    Name = "nat_instance"
  }
}

resource "aws_eip" "nat" {
  instance = """
  vpc = true
}

resource "aws_subnet" "rails_public" {
  vpc_id = 
  cidr_block = 
  availability_zone = 
  tags =  {
    Name = """
  }
}
output "public_subnet_id" {
  value = ""
}

resource "aws_route_table" "rails_public" {
  vpc_id = "${aws_vpc.default.id}"
  route {
    cidr_block = ""
    gateway_id = ""
  }
  tags =  {
    Name = ""
  }
}

resource "aws_route_table_association" "rails_public" {
  subnet_id = ""
  route_table_id = ""
}

#
# Private Subnet
#
resource "aws_subnet" "rails_private" {
  vpc_id = "${aws_vpc.default.id}"
  cidr_block = "${var.private_subnet_cidr}"
  availability_zone = "${element(var.availability_zones, 0)}"
  tags =  {
    Name = ""terraform_private_subnet"
  }
}
output "private_subnet_id" {
  value = "${aws_subnet.rails_private.id}"
}

resource "aws_route_table" "rails_private" {
  vpc_id = "${aws_vpc.default.id}"
  route {
    cidr_block = ""0.0.0.0/0"
    instance_id = "${aws_instance.nat.id}"
  }
  tags =  {
    Name = "private_subnet_route_table"
  }
}

resource "aws_route_table_association" "rails_private" {
  subnet_id = "${aws_subnet.rails_private.id}"
  route_table_id = "${aws_route_table.rails_private.id}"
}
