# Bastion
resource "aws_instance" "appliance-bastion-pub-2c" {
  ami           = data.aws_ami.amzn2.id
  instance_type = "t2.micro"
  availability_zone = "${var.aws_region}c"

  subnet_id = aws_subnet.appliance-pub-2c.id
  key_name = "${var.appliance_bastion_key}"
  associate_public_ip_address = true

  security_groups = [aws_security_group.appliance-bastion-sg.id]
  
  lifecycle {
    ignore_changes = all
  }

  tags = {
    Name = "appliance-bastion-pub-2c"
  }
}

resource "aws_instance" "appliance-01-pub-2a" {
  ami           = data.aws_ami.amzn2.id
  instance_type = "t2.micro"
  availability_zone = "${var.aws_region}a"

  subnet_id = aws_subnet.appliance-pub-2a.id
  key_name = "${var.appliance_key}"
  associate_public_ip_address = true
  
  user_data = file("./userdata/appliance_userdata.sh")

  security_groups = [aws_security_group.appliance-sg.id]
  
#   lifecycle {
#     ignore_changes = all
#   }

  tags = {
    Name = "appliance-01-pub-2a"
  }
}

resource "aws_instance" "appliance-02-pub-2c" {
  ami           = data.aws_ami.amzn2.id
  instance_type = "t2.micro"
  availability_zone = "${var.aws_region}c"

  subnet_id = aws_subnet.appliance-pub-2c.id
  key_name = "${var.appliance_key}"
#   associate_public_ip_address = true
  
  user_data = file("./userdata/appliance_userdata.sh")

  security_groups = [aws_security_group.appliance-sg.id]
  
#   lifecycle {
#     ignore_changes = all
#   }

  tags = {
    Name = "appliance-02-pub-2c"
  }
}


# ------------------------------------------------------------

# # APP01 EC2
# resource "aws_instance" "app01-web-2a" {
#   ami           = data.aws_ami.amzn2.id
#   instance_type = "${var.app01_web_type}"
#   availability_zone = "${var.aws_region}a"

#   subnet_id = aws_subnet.app01-pri-2a.id
#   key_name = "${var.app01_web_key}"

# #   user_data = templatefile("./userdata/scn_userdata.sh", { s3_bucket_path = "${var.s3_bucket_path}" })

#   security_groups = [aws_security_group.app01-web-sg.id]

#   tags = {
#     Name = "app01-web-2a"
#   }
# }



# # Security Groups
# resource "aws_security_group" "app01-web-sg" {
#   name        = "app01-web-sg"
# #   description = "Allow Bastion inbound traffic"
#   vpc_id      = aws_vpc.app01-vpc.id

#   ingress {
#     description      = "Allow SSH from Anywhere"
#     from_port        = 22
#     to_port          = 22
#     protocol         = "tcp"
#     cidr_blocks      = ["0.0.0.0/0"]
#   }

#   ingress {
#     description      = "Allow HTTP from Anywhere"
#     from_port        = 80
#     to_port          = 80
#     protocol         = "tcp"
#     cidr_blocks      = ["0.0.0.0/0"]
#   }

#   egress {
#     from_port        = 0
#     to_port          = 0
#     protocol         = "-1"
#     cidr_blocks      = ["0.0.0.0/0"]
#     ipv6_cidr_blocks = ["::/0"]
#   }

#   tags = {
#     Name = "app01-web-sg"
#   }
# }

resource "aws_security_group" "appliance-bastion-sg" {
  name        = "appliance-bastion-sg"
  vpc_id      = aws_vpc.appliance-vpc.id

  ingress {
    description      = "Allow SSH from Anywhere"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "Allow HTTP from Anywhere"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "appliance-bastion-sg"
  }
}

resource "aws_security_group" "appliance-sg" {
  name        = "appliance-sg"
  vpc_id      = aws_vpc.appliance-vpc.id

  ingress {
    description      = "Allow SSH from Anywhere"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  
  ingress {
    description      = "Allow GWLB from GWLB LB"
    from_port        = 6081
    to_port          = 6081
    protocol         = "udp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "All Open"
    from_port        = 0
    to_port          = 0
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "appliance-bastion-sg"
  }
}