# use data source to get all avalablility zones in region
data "aws_availability_zones" "available_zones" {}

# create default vpc if one does not exit
resource "aws_default_vpc" "default_vpc" {
  tags    = {
    Name  = "default vpc"
  }
}

# create default subnet if one does not exit
resource "aws_default_subnet" "default_az1" {
  availability_zone = data.aws_availability_zones.available_zones.names[0]
  tags   = {
    Name = "default subnet"
  }
}

# create security group for the ec2 instance
resource "aws_security_group" "ec2_security_group" {
  name        = "ec2 security group"
  description = "allow access on ports 8080 and 22"
  vpc_id      = aws_default_vpc.default_vpc.id

  # allow access on port 8080
  ingress {
    description      = "http proxy access"
    from_port        = 8080
    to_port          = 8080
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  # allow access on port 22
  ingress {
    description      = "ssh access"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = -1
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags   = {
    Name = "testing_app"
  }
}

#creating aws_instance by using all of the previously created components
resource "aws_instance" "web" {
  ami = "ami-09cd747c78a9add63"
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.ec2_security_group.id]
  subnet_id = aws_default_subnet.default_az1.id
  user_data = ""
  key_name = "default_key"
  tags = {
    Name = "Test_Instance"
  }

}