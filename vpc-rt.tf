# --------------------------------
# SEC VPC Route Tables
# --------------------------------
resource "aws_route_table" "sec-ingress-rt" {
  vpc_id = aws_vpc.sec-vpc.id

  route {
    cidr_block = "10.20.1.0/24"
    vpc_endpoint_id = aws_vpc_endpoint.sec-gwlb-ep-2a.id
  }

  route {
    cidr_block = "10.20.3.0/24"
    vpc_endpoint_id = aws_vpc_endpoint.sec-gwlb-ep-2c.id
  }

  route {
    cidr_block = "10.20.11.0/24"
    vpc_endpoint_id = aws_vpc_endpoint.sec-gwlb-ep-2a.id
  }

  route {
    cidr_block = "10.20.13.0/24"
    vpc_endpoint_id = aws_vpc_endpoint.sec-gwlb-ep-2c.id
  }

  tags = {
    Name = "sec-ingress-rt"
  }
}

resource "aws_route_table_association" "sec-ingress-igw-rt" {
  gateway_id     = aws_internet_gateway.sec-igw.id
  route_table_id = aws_route_table.sec-ingress-rt.id
}

resource "aws_route_table" "sec-gwlb-rt" {
  vpc_id = aws_vpc.sec-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.sec-igw.id
  }

  tags = {
    Name = "sec-gwlb-rt"
  }
}

resource "aws_route_table_association" "sec-gwlb-2a-rt" {
  subnet_id      = aws_subnet.sec-gwlb-2a.id
  route_table_id = aws_route_table.sec-gwlb-rt.id
}

resource "aws_route_table_association" "sec-gwlb-2c-rt" {
  subnet_id      = aws_subnet.sec-gwlb-2c.id
  route_table_id = aws_route_table.sec-gwlb-rt.id
}

resource "aws_route_table" "sec-pub-2a-rt" {
  vpc_id = aws_vpc.sec-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    vpc_endpoint_id = aws_vpc_endpoint.sec-gwlb-ep-2a.id
  }

  route {
    cidr_block = "10.10.0.0/16"
    transit_gateway_id = aws_ec2_transit_gateway.gwlb-tg.id
  }

  tags = {
    Name = "sec-pub-2a-rt"
  }
}

resource "aws_route_table_association" "sec-pub-2a-rt" {
  subnet_id      = aws_subnet.sec-pub-2a.id
  route_table_id = aws_route_table.sec-pub-2a-rt.id
}

resource "aws_route_table" "sec-pub-2c-rt" {
  vpc_id = aws_vpc.sec-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    vpc_endpoint_id = aws_vpc_endpoint.sec-gwlb-ep-2c.id
  }

  route {
    cidr_block = "10.10.0.0/16"
    transit_gateway_id = aws_ec2_transit_gateway.gwlb-tg.id
  }

  tags = {
    Name = "sec-pub-2c-rt"
  }
}

resource "aws_route_table_association" "sec-pub-2c-rt" {
  subnet_id      = aws_subnet.sec-pub-2c.id
  route_table_id = aws_route_table.sec-pub-2c-rt.id
}


resource "aws_route_table" "sec-tgw-2a-rt" {
  vpc_id = aws_vpc.sec-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.sec-pub-2a-nat.id
  }

  tags = {
    Name = "sec-tgw-2a-rt"
  }

  depends_on = [aws_nat_gateway.sec-pub-2a-nat]
}

resource "aws_route_table_association" "sec-tgw-2a-rt" {
  subnet_id      = aws_subnet.sec-tgw-2a.id
  route_table_id = aws_route_table.sec-tgw-2a-rt.id
}

resource "aws_route_table" "sec-tgw-2c-rt" {
  vpc_id = aws_vpc.sec-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.sec-pub-2c-nat.id
  }

  tags = {
    Name = "sec-tgw-2c-rt"
  }

  depends_on = [aws_nat_gateway.sec-pub-2c-nat]
}

resource "aws_route_table_association" "sec-tgw-2c-rt" {
  subnet_id      = aws_subnet.sec-tgw-2c.id
  route_table_id = aws_route_table.sec-tgw-2c-rt.id
}

# --------------------------------
# APPLIANCE VPC Route Tables
# --------------------------------
resource "aws_route_table" "appliance-pub-rt" {
  vpc_id = aws_vpc.appliance-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.appliance-igw.id
  }

  tags = {
    Name = "appliance-pub-rt"
  }
}

resource "aws_route_table_association" "appliance-pub-2a-rt" {
  subnet_id      = aws_subnet.appliance-pub-2a.id
  route_table_id = aws_route_table.appliance-pub-rt.id
}

resource "aws_route_table_association" "appliance-pub-2c-rt" {
  subnet_id      = aws_subnet.appliance-pub-2c.id
  route_table_id = aws_route_table.appliance-pub-rt.id
}

# --------------------------------
# APP01 VPC Route Tables
# --------------------------------
resource "aws_route_table" "app01-pri-rt" {
  vpc_id = aws_vpc.app01-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    transit_gateway_id = aws_ec2_transit_gateway.gwlb-tg.id
  }

  tags = {
    Name = "app01-pri-rt"
  }
}

resource "aws_route_table_association" "app01-pri-2a-rt" {
  subnet_id      = aws_subnet.app01-pri-2a.id
  route_table_id = aws_route_table.app01-pri-rt.id
}

resource "aws_route_table_association" "app01-pri-2c-rt" {
  subnet_id      = aws_subnet.app01-pri-2c.id
  route_table_id = aws_route_table.app01-pri-rt.id
}

