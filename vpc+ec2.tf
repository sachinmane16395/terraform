resource "aws_vpc" "first" {
  cidr_block = "192.168.0.0/16"
  tags = {
    Name = "first"
  }
}
resource "aws_subnet" "subnet1" {
  cidr_block = "192.168.1.0/24"
  vpc_id     = aws_vpc.first.id
  availability_zone= "ap-south-1b"
  tags = {
    name = "subnet1"
  }
}
resource "aws_internet_gateway" "ig1" {
    vpc_id=aws_vpc.first.id
    tags = {
    name = "ig1"
  }
}
resource aws_route_table "rt"{
    vpc_id=aws_vpc.first.id
    route {
        cidr_block="0.0.0.0/0"
        gateway_id=aws_internet_gateway.ig1.id
    }
}

resource "aws_route_table_association" "ass" {
    subnet_id=aws_subnet.subnet1.id
    route_table_id=aws_route_table.rt.id
}

data "aws_key_pair" "mykey" {
  key_name           = "devops1"
  include_public_key = true
}
resource "aws_instance" "ec2" {
    ami = "ami-01a4f99c4ac11b03c"
    instance_type = "t2.small"
    associate_public_ip_address=true
    key_name= data.aws_key_pair.mykey.key_name
    subnet_id=aws_subnet.subnet1.id
    
    
    
}





