# SEC VPC Route Tables

# APPLIANCE VPC Route Tables
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

# APP01 VPC Route Tables


