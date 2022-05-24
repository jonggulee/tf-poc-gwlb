# --------------------------------
# Transit Gateway
# --------------------------------
resource "aws_ec2_transit_gateway" "gwlb-tg" {
  auto_accept_shared_attachments = "enable"
  default_route_table_association = "disable"
  default_route_table_propagation = "disable"
  
  tags = {
    Name = "gwlb-tg"
  }
}

# --------------------------------
# Transit gateway attachments
# --------------------------------
resource "aws_ec2_transit_gateway_vpc_attachment" "gwlb-tg-sec-attach" {
  subnet_ids         = [aws_subnet.sec-tgw-2a.id, aws_subnet.sec-tgw-2c.id]
  transit_gateway_id = aws_ec2_transit_gateway.gwlb-tg.id
  vpc_id             = aws_vpc.sec-vpc.id

  transit_gateway_default_route_table_association = false
  transit_gateway_default_route_table_propagation = false
  
  tags = {
    Name = "gwlb-tg-sec-attach"
  }
}

resource "aws_ec2_transit_gateway_vpc_attachment" "gwlb-tg-app01-attach" {
  subnet_ids         = [aws_subnet.app01-tgw-2a.id, aws_subnet.app01-tgw-2c.id]
  transit_gateway_id = aws_ec2_transit_gateway.gwlb-tg.id
  vpc_id             = aws_vpc.app01-vpc.id

  transit_gateway_default_route_table_association = false
  transit_gateway_default_route_table_propagation = false
  
  tags = {
    Name = "gwlb-tg-app01-attach"
  }
}

# --------------------------------
# Route Tables - OUT
# --------------------------------
resource "aws_ec2_transit_gateway_route_table" "gwlb-tg-rt-out-tgrt" {
  transit_gateway_id = aws_ec2_transit_gateway.gwlb-tg.id
  
  tags = {
    Name = "gwlb-tg-out-tgrt"
  }
}

resource "aws_ec2_transit_gateway_route_table_association" "gwlb-tg-app01-out-ass" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.gwlb-tg-app01-attach.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.gwlb-tg-rt-out-tgrt.id
}

resource "aws_ec2_transit_gateway_route_table_propagation" "gwlb-tg-sec-out-pro" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.gwlb-tg-sec-attach.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.gwlb-tg-rt-out-tgrt.id
}

resource "aws_ec2_transit_gateway_route" "gwlb-tg-rt-out-rt" {
  destination_cidr_block         = "0.0.0.0/0"
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.gwlb-tg-sec-attach.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.gwlb-tg-rt-out-tgrt.id
}

# --------------------------------
# Route Tables - IN
# --------------------------------
resource "aws_ec2_transit_gateway_route_table" "gwlb-tg-rt-in-tgrt" {
  transit_gateway_id = aws_ec2_transit_gateway.gwlb-tg.id
  
  tags = {
    Name = "gwlb-tg-in-tgrt"
  }
}

resource "aws_ec2_transit_gateway_route_table_association" "gwlb-tg-app01-in-ass" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.gwlb-tg-sec-attach.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.gwlb-tg-rt-in-tgrt.id
}

resource "aws_ec2_transit_gateway_route_table_propagation" "gwlb-tg-sec-in-pro" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.gwlb-tg-app01-attach.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.gwlb-tg-rt-in-tgrt.id
}
