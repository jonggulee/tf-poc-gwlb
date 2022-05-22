# GWLB ENDPOINT

resource "aws_vpc_endpoint_service" "gwlb-eps" {
  acceptance_required        = false
  gateway_load_balancer_arns = [aws_lb.appliance-gwlb.arn]

  tags = {
    Name = "gwlb-eps"
  }
}

resource "aws_vpc_endpoint" "sec-gwlb-ep-2a" {
  service_name      = aws_vpc_endpoint_service.gwlb-eps.service_name
  subnet_ids        = [aws_subnet.sec-gwlb-2a.id]
  vpc_endpoint_type = aws_vpc_endpoint_service.gwlb-eps.service_type
  vpc_id            = aws_vpc.sec-vpc.id

  tags = {
    Name = "sec-gwlb-ep-2a"
  }
}

resource "aws_vpc_endpoint" "sec-gwlb-ep-2c" {
  service_name      = aws_vpc_endpoint_service.gwlb-eps.service_name
  subnet_ids        = [aws_subnet.sec-gwlb-2c.id]
  vpc_endpoint_type = aws_vpc_endpoint_service.gwlb-eps.service_type
  vpc_id            = aws_vpc.sec-vpc.id

  tags = {
    Name = "sec-gwlb-ep-2c"
  }
}