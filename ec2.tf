# --------------------------------
# Bastion Instances
# --------------------------------
resource "aws_instance" "sec-bastion-pub-2c" {
  ami           = data.aws_ami.amzn2.id
  instance_type = "t2.micro"
  availability_zone = "${var.aws_region}c"

  subnet_id = aws_subnet.sec-pub-2c.id
  key_name = "${var.appliance_bastion_key}"
  associate_public_ip_address = true

  security_groups = [aws_security_group.sec-bastion-sg.id]
  
  lifecycle {
    ignore_changes = all

  }

  tags = {
    Name = "sec-bastion-pub-2c"
  }
}

# --------------------------------
# Appliance Instances
# --------------------------------
resource "aws_instance" "appliance-01-pub-2a" {
  ami           = data.aws_ami.amzn2.id
  instance_type = "t2.micro"
  availability_zone = "${var.aws_region}a"

  subnet_id = aws_subnet.appliance-pub-2a.id
  key_name = "${var.appliance_key}"
  associate_public_ip_address = true
  
  user_data = file("./userdata/appliance_userdata.sh")

  security_groups = [aws_security_group.appliance-sg.id]
  
  lifecycle {
    ignore_changes = all
  }
  
  iam_instance_profile = aws_iam_instance_profile.amazon_ec2_role_for_get_info_iam.id

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
  associate_public_ip_address = true

  user_data = file("./userdata/appliance_userdata.sh")

  security_groups = [aws_security_group.appliance-sg.id]
  
  lifecycle {
    ignore_changes = all
  }

  iam_instance_profile = aws_iam_instance_profile.amazon_ec2_role_for_get_info_iam.id

  tags = {
    Name = "appliance-02-pub-2c"
  }
}

# --------------------------------
# APP01 Instances
# --------------------------------
resource "aws_instance" "app01-web-01-pri-2a" {
  ami           = data.aws_ami.amzn2.id
  instance_type = "${var.app01_web_type}"
  availability_zone = "${var.aws_region}a"

  subnet_id = aws_subnet.app01-pri-2a.id
  key_name = "${var.app01_web_key}"
  
  user_data = file("./userdata/app01_web_userdata.sh")

  security_groups = [aws_security_group.app01-web-sg.id]
  
  lifecycle {
    ignore_changes = all
  }

  depends_on = [aws_lb.app01-web-nlb, aws_instance.appliance-01-pub-2a, aws_ec2_transit_gateway.gwlb-tg]

  tags = {
    Name = "app01-web-01-pri-2a"
  }
}

resource "aws_instance" "app01-web-02-pri-2c" {
  ami           = data.aws_ami.amzn2.id
  instance_type = "${var.app01_web_type}"
  availability_zone = "${var.aws_region}c"

  subnet_id = aws_subnet.app01-pri-2c.id
  key_name = "${var.app01_web_key}"
  
  user_data = file("./userdata/app01_web_userdata.sh")

  security_groups = [aws_security_group.app01-web-sg.id]
  
  lifecycle {
    ignore_changes = all
  }

  depends_on = [aws_lb.app01-web-nlb, aws_instance.appliance-02-pub-2c, aws_ec2_transit_gateway.gwlb-tg]

  tags = {
    Name = "app01-web-02-pri-2c"
  }
}

resource "aws_security_group" "sec-bastion-sg" {
  name        = "sec-bastion-sg"
  vpc_id      = aws_vpc.sec-vpc.id

  ingress {
    description      = "Allow SSH from Anywhere"
    from_port        = 22
    to_port          = 22
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
    Name = "sec-bastion-sg"
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
    description      = "Allow HTTP from Anywhere"
    from_port        = 80
    to_port          = 80
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

resource "aws_security_group" "app01-web-sg" {
  name        = "app01-web-sg"
  vpc_id      = aws_vpc.app01-vpc.id

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
    Name = "app01-web-sg"
  }
}

resource "aws_security_group" "sec-app01-web-alb-sg" {
  name        = "sec-app01-web-alb-sg"
  vpc_id      = aws_vpc.sec-vpc.id

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
    Name = "sec-app01-web-alb-sg"
  }
}
