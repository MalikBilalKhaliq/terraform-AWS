# create default vpc if one does not exit
resource "aws_default_vpc" "default_vpc" {

  tags    = {
    Name  = "default vpc"
  }
}

# use data source to get all avalablility zones in region
data "aws_availability_zones" "available_zones" {}

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
    Name = "jenkins master server security group"
  }
}


# use data source to get a registered amazon linux 2 ami
# data "aws_ami" "amazon_linux_2" {
#   most_recent = true
#   owners      = ["amazon"]
  
#   filter {
#     name   = "owner-alias"
#     values = ["amazon"]
#   }

#   filter {
#     name   = "name"
#     values = ["amzn2-ami-hvm*"]
#   }
# }

###########################################
# A local value assigns a name to an expression, so you can use 
# the name multiple times within a module instead of repeating the expression

variable "configuration" {
  description = "The total configuration, List of Objects/Dictionary"
  default = [{}]
}

locals {
  serverconfig = [
    for srv in var.configuration : [
      for i in range(1, srv.no_of_instances+1) : {
        instance_name = "${srv.application_name}-${i}"
        instance_type = srv.instance_type
        subnet_id   = aws_default_subnet.default_az1.id
        # operating_system     = "Ubuntu 20.04-server x86_64"
        ami = srv.operating_system
        security_groups = [aws_security_group.ec2_security_group.id]
        dependencies = srv.dependencies
      }
    ]
  ]
}

# The resource for_each and dynamic block language features 
# both require a collection value that has one element for each repetition.
# flatten takes a list and replaces any elements 
# that are lists with a flattened sequence of the list contents.
locals {
  instances = flatten(local.serverconfig)
}

#Below create the aws instance by making use of for_each meta argument to execute things in a loop
resource "aws_instance" "web" {
  for_each = {for server in local.instances: server.instance_name =>  server}
  ami = each.value.ami
  instance_type = each.value.instance_type
  vpc_security_group_ids = each.value.security_groups
  subnet_id = each.value.subnet_id
  key_name = "default_key"
  tags = {
    Name = "${each.value.instance_name}"
  }

  provisioner "file" {
    source      = each.value.dependencies
    destination = format("%s/%s","/tmp/",each.value.dependencies)
  }

  provisioner "remote-exec" {
    inline = [
      format("%s/%s","chmod +x /tmp/",each.value.dependencies),
      format("%s/%s","/tmp/",each.value.dependencies),
    ]
  }
  connection {
      type        = "ssh"
      host        = self.public_ip
      user        = "ubuntu"
      private_key = file("/testing/default_key.pem")
      timeout     = "8m"
   }

}

#this is to display the whole instances after successfully deployment
 output "instance_name" {
  value = toset([
    for bd in aws_instance.web : bd
  ])
}
